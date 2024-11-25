import json
import boto
import datetime
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)
ec2_client = boto3.client('ec2')
s3_client = boto3.client('s3')
EBS_VOLUME_IDS = ['vol-010d857e1f107fa83', 'vol-02b4d2d8171deba01']
S3_BUCKET_NAME = 'all-purposes-yannick-bucket'

def lambda_handler(event, context):
    for ebs_volume_id in EBS_VOLUME_IDS:
        try:
            snapshot = ec2_client.create_snapshot(
                VolumeId=ebs_volume_id,
                Description=f'Snapshot taken by Lambda function for volume {ebs_volume_id}'
            )

            logger.info(f'Snapshot created with ID: {snapshot["SnapshotId"]} for volume {ebs_volume_id}')

            snapshot_metadata = {
                'SnapshotId': snapshot['SnapshotId'],
                'VolumeId': ebs_volume_id,
                'StartTime': str(snapshot['StartTime']),
                'Description': snapshot['Description']
            }

            timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
            s3_object_key = f'snapshots/snapshot-{snapshot["SnapshotId"]}-{timestamp}.json'

            s3_client.put_object(
                Bucket=S3_BUCKET_NAME,
                Key=s3_object_key,
                Body=json.dumps(snapshot_metadata),
                ContentType='application/json'
            )

            logger.info(f'Snapshot metadata uploaded to S3 at {s3_object_key}')

        except Exception as e:
            logger.error(f'Error creating snapshot for volume {ebs_volume_id} or uploading metadata: {str(e)}')
            return {
                'statusCode': 500,
                'body': json.dumps(f'Error creating snapshot for volume {ebs_volume_id}.')
            }

    return {
        'statusCode': 200,
        'body': json.dumps('Snapshots created and metadata stored successfully.')
    }



# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CreateSnapshot",
#                 "ec2:DescribeVolumes",
#                 "s3:PutObject"
#             ],
#             "Resource": "*"
#         }
#     ]
# }

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "dev1_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "dev2_vpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_vpc_peering_connection" "peering_connection" {
  peer_vpc_id = aws_vpc.dev1_vpc.id
  vpc_id      = aws_vpc.dev2_vpc.id
  auto_accept = true

  tags = {
    Name = "Connection from dev1 to dev2"
  }
}

resource "aws_route" "route_for_dev1" {
  destination_cidr_block = aws_vpc.dev1_vpc.cidr_block
  route_table_id = aws_vpc.dev1_vpc.main_route_table_id
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

resource "aws_route" "route_for_dev2" {
  destination_cidr_block = aws_vpc.dev2_vpc.cidr_block
  route_table_id = aws_vpc.dev2_vpc.id
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

resource "aws_instance" "server_in_dev1" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "c6a.2xlarge"
  subnet_id     = aws_vpc.dev1_vpc

  cpu_options {
    core_count       = 2
    threads_per_core = 2
  }

  tags = {
    Name = "tf-example"
  }

#  name          = "app-lt"
#  instance_type = local.instance_type
#  image_id      = local.ami_id
#  key_name      = local.key_pair_name
#  user_data     = base64encode(local.user_data_app)
#
#  network_interfaces {
#    security_groups             = [aws_security_group.app_sg.id]
#    associate_public_ip_address = true
#  }
#
#  tags = {
#    Name = "Application Instance"
#  }
}

resource "aws_instance" "server_in_dev2" {

}
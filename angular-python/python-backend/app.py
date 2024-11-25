from flask import Flask, jsonify, request
from flask_cors import CORS
from datetime import date

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})


@app.route('/', methods=['GET'])
def greeting():
    return jsonify({"message": "Hello from python back-end"})

@app.route('/date', methods=['GET'])
def todayDate():
    today_date = date.today()
    return jsonify({"date": f"{today_date}"})

@app.route('/products', methods=['GET'])
def getProducts():
    products = ['shoes', 'clothes', 'hats', 'jewelry']
    return products


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000,debug=True)

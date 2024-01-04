import boto3
from flask import Flask, request, jsonify
from flask_restful import Resource, Api
from flask_cors import CORS

application = Flask(__name__)
api = Api(application)
CORS(application, origins=["https://www.outworldindustries.com"])

dynamodb = boto3.resource('dynamodb', region_name='eu-central-1')
table = dynamodb.Table('Fortunes')

class HelloWorld(Resource):
    def get(self):
        return {'hello': 'world'}

class ScanFortune(Resource):
    def get(self):
        response = table.scan()
        items = response['Items']
        print(items)
        return jsonify(items)

class ReadFortune(Resource):
    def get(self):
        fortune_key = request.args.get('readfortune')
        origin_key = request.args.get('readorigin')
        response = table.get_item(
            Key={
                'FortuneName': fortune_key,
                'FortuneOrigin': origin_key
            }
        )
        item = response['Item']
        return jsonify(item)

class CreateFortune(Resource):
    def post(self):
        fortune = request.form['createfortune']
        origin = request.form['createorigin']
        table.put_item(
            Item={
            'FortuneName': fortune,
            'FortuneOrigin': origin
            }
        )

class UpdateFortune(Resource):
    def post(self):
        fortune_key = request.form['updatefortune']
        origin_key = request.form['updateorigin']
        author = request.form['updateattribute1']
        color = request.form['updateattribute2']
        response = table.update_item(
            Key={
                'FortuneName': fortune_key,
                'FortuneOrigin': origin_key
            },
            AttributeUpdates={
                'FortuneAuthor': {
                    'Value'  : author,
                    'Action' : 'PUT' # available options -> DELETE(delete), PUT(set), ADD(increment)
                },
                'FortuneColor': {
                    'Value'  : color,
                    'Action' : 'PUT' # available options -> DELETE(delete), PUT(set), ADD(increment)
                }
            }
        )

class DeleteFortune(Resource):
    def post(self):
        fortune_key = request.form['deletefortune']
        origin_key = request.form['deleteorigin']
        response = table.delete_item(
            Key={
                'FortuneName': fortune_key,
                'FortuneOrigin': origin_key
            }
        )

api.add_resource(HelloWorld, '/')
api.add_resource(ScanFortune, '/scanfortune')
api.add_resource(ReadFortune, '/readfortune')
api.add_resource(CreateFortune, '/createfortune')
api.add_resource(UpdateFortune, '/updatefortune')
api.add_resource(DeleteFortune, '/deletefortune')

if __name__ == '__main__':
    application.run(debug=True)

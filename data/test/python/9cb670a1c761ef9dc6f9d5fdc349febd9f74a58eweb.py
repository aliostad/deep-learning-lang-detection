from flask import Flask,jsonify,send_from_directory,request
from flask.ext import restful
from flask.ext.restless import APIManager
from flask.ext.restful.utils import cors

from backend.user import User
from backend.simulation import Simulation,Argument,Diagnostic
from backend.kernel import Kernel,Note
from json_encoding import new_alchemy_encoder

import backend.database as db

app = Flask(__name__)
app.json_encoder = new_alchemy_encoder()
app.debug=True
#This is for RPC api
# api = restful.Api(app)
# api.decorators=[cors.crossdomain(origin='*',headers=['Origin', 'X-Requested-With', 'Content-Type', 'Accept'])]

# api.add_resource(resources.customer.Customer, '/api/customers/<string:uid>')
# api.add_resource(resources.customer.Customers, '/api/customers')
# api.add_resource(resources.dataset.Dataset, '/api/datasets/<string:uid>')
# api.add_resource(resources.dataset.Datasets, '/api/datasets')
# api.add_resource(resources.entry.Entry, '/api/entries/<string:uid>')
# api.add_resource(resources.entry.Entries, '/api/entries')
# api.add_resource(resources.user.User, '/api/users/<string:uid>')
# api.add_resource(resources.user.Users, '/api/users')
# api.add_resource(resources.schema.DatasetColumns, '/api/datasetColumns')
# api.add_resource(resources.schema.DatasetColumn, '/api/datasetColumns/<string:uid>')
# api.add_resource(resources.schema.EntryCells, '/api/entryCells')
# api.add_resource(resources.schema.DatasetColumnOptions,'/api/datasetColumnOptions')

#This is for data api
manager = APIManager(app, session=db.Session())


manager.create_api(User)
manager.create_api(Simulation)
manager.create_api(Argument)
manager.create_api(Diagnostic)
manager.create_api(Kernel)
manager.create_api(Note)


if __name__ == '__main__':
    app.run(debug=True)
from flask import Flask
from flask.ext.restful import Api
from api import IndexApi, RoadsApi, CitiesApi, CitiesIdApi, CountriesApi


app = Flask(__name__)
app.config['DEBUG'] = True

api = Api(app)
api.add_resource(IndexApi, '/', '/index')

api.add_resource(RoadsApi, '/', '/api/roads')
api.add_resource(CitiesApi, '/', '/api/cities')
api.add_resource(CitiesIdApi, '/', '/api/cities/<id>')
api.add_resource(CountriesApi, '/', '/api/countries')

if __name__ == "__main__":
    print "App is running!"
    app.run()



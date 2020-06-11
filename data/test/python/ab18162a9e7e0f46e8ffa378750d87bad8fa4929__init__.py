from flask.ext.restful import Api
from irianas_server.api import \
    (LoginAPI, UserAPI, ClientAPI, ClientBasicTaskAPI, ClientServicesAPI,
     InfoAPI, EventAPI, UserRecordAPI, ClientConfigServicesAPI,
     PutConfigService)


def build_app(app):
    api = Api(app)
    api.add_resource(InfoAPI, '/info')
    api.add_resource(LoginAPI, '/login/<string:user>', '/login')
    api.add_resource(UserRecordAPI, '/user/record')
    api.add_resource(UserAPI, '/user/<string:action>', '/user')
    api.add_resource(ClientAPI, '/client/<string:action>', '/client')
    api.add_resource(ClientBasicTaskAPI, '/client/task/<string:action>')
    api.add_resource(ClientServicesAPI,
                     '/client/services/<string:services>/<string:action>')
    api.add_resource(EventAPI, '/client/events')
    api.add_resource(ClientConfigServicesAPI, '/client/services')

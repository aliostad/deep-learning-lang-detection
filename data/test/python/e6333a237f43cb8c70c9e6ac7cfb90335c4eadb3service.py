import falcon

from belzoni.operation.api.api import OperationAPI
from wsgiref import simple_server

#import OperationAPI

service_api = application = falcon.API()

storage_path ="/home/mehdi/Pictures/"

operation_api = OperationAPI(storage_path)

service_api.add_route('/operation', operation_api)
#service_api.add_route('/operation/{owner}/{operation_name}/', operation_api)
#service_api.add_route('/operation/{operation_id}', operation_api)


# Useful for debugging problems in your API; works with pdb.set_trace()
if __name__ == '__main__':
    httpd = simple_server.make_server('127.0.0.1', 8000, service_api)
    httpd.serve_forever()
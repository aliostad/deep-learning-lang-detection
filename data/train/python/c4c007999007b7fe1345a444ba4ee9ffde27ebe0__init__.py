from flask_restplus import Api, Namespace

from app.api.cve.apiController import api as ns1
from app.api.user.apiController import api as ns2
from app.api.oauth.apiController import api as ns3
from app.api.es.apiController import api as ns4


api = Api(version='2.2', \
            title='Flask Restful plus Api', \
            doc='/api', \
            description='Document for Restful api', \
            contact='tsungwu@cyber00rn.org', \
            default='tweet')


api.add_namespace(ns1, path='/api/cves')
api.add_namespace(ns2, path='/api/users')
api.add_namespace(ns3, path='/api/oauth')
api.add_namespace(ns4, path='/api/es')

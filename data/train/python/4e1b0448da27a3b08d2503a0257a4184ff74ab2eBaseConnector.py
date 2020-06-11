import urllib3
import simplejson

from api.config.API import API

"""
@class      BaseConnector
@author     Nils Berlijn
@version    1.0
@since      1.0
"""
class BaseConnector():
    api = API()
    http = urllib3.PoolManager()

    def __init__(self):
        pass

    def connect(self, api_key, data):
        if self.__authenticate(api_key):
            return data
        else:
            return self.__unauthorized()

    def __authenticate(self, api_key):
        if api_key == self.api.api_key():
            return True

    @staticmethod
    def __unauthorized():
        return simplejson.dumps({
            'status': 401,
            'message': 'Unauthorized',
            'description': 'A valid API key is required.'
        })

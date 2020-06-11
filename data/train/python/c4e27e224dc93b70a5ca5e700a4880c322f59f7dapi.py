
from django.conf import settings

from cannula.utils import import_object

class LazyAPI(object):
    
    def __init__(self, dotted_path):
        self._dotted_path = dotted_path
        self._api = None
    
    def __getattr__(self, attr):
        if not self._api:
            klass = import_object(self._dotted_path)
            self._api = klass()
        return getattr(self._api, attr)
    
class API:
    
    #clusters = LazyAPI(CANNULA_API['clusters'])
    deploy = LazyAPI(settings.CANNULA_API['deploy'])
    groups = LazyAPI(settings.CANNULA_API['groups'])
    keys = LazyAPI(settings.CANNULA_API['keys'])
    log = LazyAPI(settings.CANNULA_API['log'])
    permissions = LazyAPI(settings.CANNULA_API['permissions'])
    proc = LazyAPI(settings.CANNULA_API['proc'])
    projects = LazyAPI(settings.CANNULA_API['projects'])
    proxy = LazyAPI(settings.CANNULA_API['proxy'])
    #servers = LazyAPI(CANNULA_API['servers'])
    users = LazyAPI(settings.CANNULA_API['users'])

api = API()
from django.conf import settings
from django.utils.importlib import import_module
from tastypie.api import Api

__author__ = 'ir4y'


def resouce_autodiscover(api_name="v1", api_module_name="api"):
    api = Api(api_name=api_name)
    for app in settings.INSTALLED_APPS:
        try:
            resorce_api = import_module('%s.%s' % (app, api_module_name))
            for resource_klass_name in resorce_api.__all__:
                resource_klass = getattr(resorce_api, resource_klass_name)
                api.register(resource_klass())
        except:
            continue
    return api

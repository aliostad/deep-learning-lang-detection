# -*- coding: utf-8 -*-
from tastypie.api import Api

from .api import CReadCategoryResource, CReadResourceBaseResource, CReadResourceResource
from .api import CReadLayerResource, CReadDocumentResource, CReadMapResource

api = Api(api_name='cread_api')

api.register(CReadCategoryResource())
api.register(CReadResourceResource())

override_api = Api(api_name='api')

override_api.register(CReadResourceBaseResource())
override_api.register(CReadLayerResource())
override_api.register(CReadDocumentResource())
override_api.register(CReadMapResource())

from django.conf.urls import url, include
from tastypie.api import Api

import views, api


v1_api = Api(api_name='v1')
v1_api.register(api.ChemicalResource())
v1_api.register(api.PropertyResource())
v1_api.register(api.AnnotationResource())
v1_api.register(api.ProductResource())
v1_api.register(api.ProductConstituent())
v1_api.register(api.ApplicationResource())

#chemical_resource=api.ChemicalResource()

urlpatterns = [
    url(r'',include(v1_api.urls)),
    url(r'modules/?',views.modules, name='modules'),
    url(r'^result$', views.moduleresults, name='module results'),
    url(r'result/(?P<resultuuid>[-0-9a-f]+)$',views.resultbyuuid, name='named result'),
    url(r'^lciaresult/?$', views.lciaresults, name='LCIA results'),
#    url(r'',include(chemical_resource.urls)),
    ]


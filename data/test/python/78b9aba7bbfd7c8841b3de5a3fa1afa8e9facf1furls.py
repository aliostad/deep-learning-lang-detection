from django.conf.urls import patterns, include, url
from tastypie.api import Api
from apis.entry.api import EntryResource
from apis.user.api import UserResource


api_beta = Api(api_name='beta')

api_beta.register(UserResource())
api_beta.register(EntryResource())

urlpatterns =  patterns( '',
  
  url(r'^', include(api_beta.urls)),

  url(r'doc/',
      include('tastypie_swagger.urls', namespace='user_tastypie_swagger'),
      kwargs={"tastypie_api_module":"apis.urls.api_beta", "namespace":"user_tastypie_swagger"}
    ),

  
  )

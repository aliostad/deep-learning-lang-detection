from django.conf.urls import *
from django.contrib import admin
from rest_framework import routers
from YqlConnect import views as YqlConnectViews
from tastypie import fields

from tastypie.api import Api
from RestApi.api import AthleteResource, FantasyTeamResource, CalculateDecisionResource, Login, CheckUser
from RestApi.apiAuth import UserResource, RequestToken, AccessToken
# router = routers.DefaultRouter()
# router.register(r'seasonAverages', RestApiViews.AthleteViewSet)
# router.register(r'fantasyTeam/user', RestApiViews.test())

v1_api = Api(api_name='v1')
v1_api.register(AthleteResource())
v1_api.register(FantasyTeamResource())
v1_api.register(CalculateDecisionResource())
v1_api.register(CheckUser())

auth_api = Api(api_name='v1')
auth_api.register(UserResource())
auth_api.register(RequestToken())
auth_api.register(AccessToken())

urlpatterns = patterns('',

    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/', include(v1_api.urls)),
    url(r'^auth/', include(auth_api.urls)),

)

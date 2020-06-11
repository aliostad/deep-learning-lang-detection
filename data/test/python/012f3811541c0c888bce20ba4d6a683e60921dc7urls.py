from django.conf.urls import patterns, include, url
from tastypie.api import Api
from base.resources import *

v1_api = Api(api_name='v1')
v1_api.register(AccountResource())
v1_api.register(UserResource())
v1_api.register(ProductResource())
v1_api.register(QuizResource())
v1_api.register(PaperResource())
v1_api.register(MarkResource())
v1_api.register(LotteryResource())
v1_api.register(ShareResource())
v1_api.register(FavoriteCategoryResource())

from notification.resources import *
v1_api.register(NotificationResource())

urlpatterns = patterns('',
    url(r'^', include(v1_api.urls))
)

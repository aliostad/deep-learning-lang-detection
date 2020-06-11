from django_messages.api import ReceivedMessageResource, SentMessageResource, TrashMessageResource
from friendship.api import FollowerResource, FollowingResource
from tastypie.api import Api
from plan.api import PlanResource
from traveller.api import TravellerResource
from notifications.api import AllNotificationResource, UnreadNotificationResource
from city.api import ProvinceResource
from django.conf.urls import patterns, url, include

__author__ = 'danielqiu'


v1_api = Api(api_name='v1')
v1_api.register(PlanResource())
v1_api.register(TravellerResource())
v1_api.register(AllNotificationResource())
v1_api.register(UnreadNotificationResource())
v1_api.register(FollowerResource())
v1_api.register(FollowingResource())
v1_api.register(ReceivedMessageResource())
v1_api.register(SentMessageResource())
v1_api.register(TrashMessageResource())
v1_api.register(ProvinceResource())

urlpatterns = patterns('',
                        url(r'^', include(v1_api.urls)),


)

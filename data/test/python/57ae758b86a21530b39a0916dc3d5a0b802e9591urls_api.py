from django.conf.urls import patterns, include
from tastypie.api import Api

from profiles.api import UserResource
from achat.api import MessageResource
from onair.api import VoteResource, ScheduledItemResource

api = Api(api_name='v1')

# onair
api.register(VoteResource())
api.register(ScheduledItemResource())

# alogin
api.register(UserResource())
api.register(MessageResource())

urlpatterns = patterns('',
    (r'^', include(api.urls)),
    # pass all so far unmatched requests to the API proxy
    (r'^', include('apiproxy.urls')),
)
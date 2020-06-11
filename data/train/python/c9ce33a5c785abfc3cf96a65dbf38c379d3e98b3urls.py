from django.conf.urls import patterns, include, url

from tastypie.api import Api
from activity.api import ActivityResource, ActivityTicketTypeResource, ActivityTicketResource, ActivityNearbyResource
from ltuser.api import UserResource,SimpleUserResource

from notice.api import NewFriendNoticeResource, AcceptFriendNoticeResource

from friend.api import GroupResource

api = Api(api_name="v1")
api.register(ActivityResource())
api.register(ActivityTicketTypeResource())
api.register(ActivityTicketResource())
api.register(ActivityNearbyResource())

api.register(UserResource())
api.register(SimpleUserResource())

api.register(NewFriendNoticeResource())
api.register(AcceptFriendNoticeResource())

api.register(GroupResource())
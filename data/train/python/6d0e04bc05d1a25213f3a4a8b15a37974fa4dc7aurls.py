from django.conf.urls import patterns, url, include
from tastypie.api import Api

from snappybouncer import api


# Setting the API base name and registering the API resources using
# Tastypies API function
api_resources = Api(api_name='v1/snappybouncer')
api_resources.register(api.ConversationResource())
api_resources.register(api.UserAccountResource())
api_resources.register(api.TicketResource())
api_resources.register(api.WebhookResource())

api_resources.prepend_urls()

# Setting the urlpatterns to hook into the api urls
urlpatterns = patterns(
    '',
    url(r'^api/', include(api_resources.urls))
)

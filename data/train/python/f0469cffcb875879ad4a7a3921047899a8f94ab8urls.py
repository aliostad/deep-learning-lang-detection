from django.conf.urls import patterns, url, include
from subscription import api
from tastypie.api import Api


# Setting the API base name and registering the API resources using
# Tastypies API function
api_resources = Api(api_name='v1')
api_resources.register(api.SubscriptionResource())
api_resources.register(api.PeriodicTaskResource())
api_resources.register(api.MessageSetResource())


api_resources.prepend_urls()

# Setting the urlpatterns to hook into the api urls
urlpatterns = patterns(
    '',
    url(r'^api/', include(api_resources.urls))
)

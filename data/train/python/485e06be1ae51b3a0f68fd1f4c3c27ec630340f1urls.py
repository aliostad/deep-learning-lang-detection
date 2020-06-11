from django.conf.urls import patterns, url, include
from servicerating import api
from tastypie.api import Api


# Setting the API base name and registering the API resources using
# Tastypies API function
api_resources = Api(api_name='v1/servicerating')
api_resources.register(api.ContactResource())
api_resources.register(api.ConversationResource())
api_resources.register(api.ResponseResource())
api_resources.register(api.UserAccountResource())
api_resources.register(api.ExtraResource())
api_resources.register(api.ServiceRatingResource())

api_resources.prepend_urls()


urlpatterns = patterns(
    '',
    # Setting the urlpatterns to hook into the api urls
    url(r'^api/', include(api_resources.urls)),
    # Admin servicerating dashboard hookup
    url(r'^admin/servicerating/dashboard/',
        'servicerating.views.dashboard'),
    url(r'^admin/servicerating/report/',
        'servicerating.views.report_responses')
)

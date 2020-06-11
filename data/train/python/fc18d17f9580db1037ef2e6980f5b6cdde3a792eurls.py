from django.conf.urls import patterns, url, include
from hierarchy import api
from tastypie.api import Api


# Setting the API base name and registering the API resources using
# Tastypies API function
api_resources = Api(api_name='v1')
api_resources.register(api.ProvinceResource())
api_resources.register(api.DistrictResource())
api_resources.register(api.ZoneResource())
api_resources.register(api.SchoolResource())
api_resources.register(api.EmisResource())

# CSV Download
api_resources.register(api.ProvinceResourceCSVDownload())
api_resources.register(api.DistrictResourceCSVDownload())
api_resources.register(api.ZoneResourceCSVDownload())
api_resources.register(api.SchoolResourceCSVDownload())
api_resources.register(api.EmisResourceCSVDownload())

api_resources.prepend_urls()

# Setting the urlpatterns to hook into the api urls
urlpatterns = patterns('',
    url(r'^api/', include(api_resources.urls))
)

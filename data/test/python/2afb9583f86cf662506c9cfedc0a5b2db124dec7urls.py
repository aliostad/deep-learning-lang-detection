from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.views.generic import TemplateView
from django.conf import settings
from django.conf.urls.static import static
from events.urls import eventapi as eventapiv2

admin.autodiscover()

# tastypie api purposes
from tastypie.api import Api

from events.api import *
from basal.api import *
v01_api = Api(api_name='v01')

v01_api.register(AddressResource())
v01_api.register(EventResource())
v01_api.register(EventRSVPResource())
v01_api.register(EventCommentResource())
v01_api.register(EventImageResource())
v01_api.register(EventLikeResource())
v01_api.register(UserResource())
v01_api.register(UserImageResource())
v01_api.register(UserTagResource())
v01_api.register(ApiTokenResource())


urlpatterns = patterns('',
    url(r'^', include('basal.urls', namespace='basal')),
    url(r'^admin/', include(admin.site.urls)),
    url(r'^events/', include('events.urls', namespace='events')),
    url(r'^api/', include(v01_api.urls)),
) + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


urlpatterns+=patterns('',
	url(r'^api/',include(eventapiv2.urls)),
)

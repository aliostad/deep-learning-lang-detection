from django.conf.urls import patterns, include, url
from django.contrib import admin
from tastypie.api import Api
from api.api import ClubResource, CalendarItemResource, GameResultResource, LeagueTableItemResource

v1_api = Api(api_name='v1')
v1_api.register(ClubResource())
v1_api.register(CalendarItemResource())
v1_api.register(GameResultResource())
v1_api.register(LeagueTableItemResource())

admin.autodiscover()

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/', include(v1_api.urls)),
)

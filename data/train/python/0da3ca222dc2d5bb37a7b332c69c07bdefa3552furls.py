from django.conf.urls import patterns, include, url
from member.resource import MemberResource
from member.resource import UserResource
from report.resource import ReportResource
from portal.resource import PortalResource
from turbine.resource import TurbineResource, TurbineDataResource
from solarcell.resource import SolarcellResource, SolarcellDataResource
from serviceconf.resource import ServiceConfResource
from django.contrib import admin
from tastypie.api import Api
from django.views.generic.base import TemplateView

#api objects
members_api = Api(api_name='members')
members_api.register(UserResource())
members_api.register(MemberResource())
members_api.register(PortalResource())

turbines_api = Api(api_name='turbines')
turbines_api.register(TurbineResource())
turbines_api.register(TurbineDataResource())

solarcells_api = Api(api_name='solarcells')
solarcells_api.register(SolarcellResource())
solarcells_api.register(SolarcellDataResource())

service_api = Api(api_name='service')
service_api.register(ServiceConfResource())

report_api = Api(api_name='report')
report_api.register(ReportResource())

admin.autodiscover()

urlpatterns = patterns('',
                       url(r'^$', TemplateView.as_view(template_name='index.jade')),
                       url(r'^api/', include(members_api.urls)),
                       url(r'^api/', include(service_api.urls)),
                       url(r'^api/', include(report_api.urls)),
                       url(r'^api/', include(turbines_api.urls)),
                       url(r'^api/', include(solarcells_api.urls)),
                       url(r'^members/', include('member.urls')),
                       url(r'^portal/', include('portal.urls')),
                       url(r'^service/', include('serviceconf.urls')),
                       url(r'^report/', include('report.urls')),
                       url(r'^turbine/', include('turbine.urls')),
                       url(r'^solarcell/', include('solarcell.urls')),
                       url(r'^surveillance/', include('surveillance.urls')),
                       url(r'^meteor/', include('meteor.urls')),
                       url(r'^power/', include('power.urls')),
                       url(r'^battery/', include('battery.urls')),
                       url(r'^admin/', include(admin.site.urls)),
                       )

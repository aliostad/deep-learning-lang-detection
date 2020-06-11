from django.conf.urls.defaults import patterns, url
from core.views.views import home
from core.views import api

urlpatterns = patterns('',
    url(r'^$', home),
    url(r'^api/get_hospitals/$', api.get_hospitals, name="api-get-hospitals"),
    url(r'^api/add_hospital/$', api.add_hospital, name="api-add-hospital"),
    url(r'^api/delete_hospital/(?P<id_>\d+)/$', api.delete_hospital,
        name="api-delete-hospital"),
    url(r'^api/edit_hospital/(?P<id_>\d+)/$', api.edit_hospital,
        name="api-edit-hospital"),
    url(r'^api/info_hospital/(?P<id_>\d+)/$', api.info_hospital,
        name="api-info-hospital"),
    url(r'^api/edit_hospital_data/(?P<key>\w+)/$', api.edit_hospital_data,
        name="api-edit-hospital-data"),
)

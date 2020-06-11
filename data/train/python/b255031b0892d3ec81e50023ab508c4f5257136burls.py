from django.conf.urls.defaults import *

urlpatterns = patterns('issues.views',
    (r'^manage/?$', 'manage_index'),
    (r'^manage/admin_report$', 'admin_report'),
    (r'^manage/new/SF/?$', 'manage_new_specialfee'),
    (r'^manage/new/(?P<issue_kind>[\w\d-]+)/?$', 'manage_new'),
    (r'^manage/create/?$', 'create'),

    (r'^$', 'index'), # added index to the regex
    (r'^(?P<show>[\w\d-]+)$', 'index'),
    (r'^issue/(?P<issue_slug>[\w\d-]+)/?$', 'detail'),

    (r'^issue/(?P<issue_slug>[\w\d-]+)/edit$', 'manage_edit'),
)

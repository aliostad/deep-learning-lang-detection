from django.conf.urls import url

from .views import show_list, create_list, mailaction, manage_whitelist, manage_settings

urlpatterns = [
    url(r'^([a-zA-Z0-9-]+)/$', show_list, name='mailinglist_show_list'),
    url(r'^([a-zA-Z0-9-]+)/create$', create_list,
            name='mailinglist_create_list'),
    url(r'^([a-zA-Z0-9-]+)/mailaction/(\d+)$', mailaction,
            name='mailinglist_mailaction'),
    url(r'^([a-zA-Z0-9-]+)/whitelist', manage_whitelist,
            name='mailinglist_whitelist'),
    url(r'^([a-zA-Z0-9-]+)/settings', manage_settings,
            name='mailinglist_settings'),
]

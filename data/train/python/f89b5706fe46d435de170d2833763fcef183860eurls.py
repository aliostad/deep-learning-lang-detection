from django.conf.urls.defaults import *

urlpatterns = patterns('newsletters.views',
    url(r'^$','newsletter_list', name="newsletters_list"),
    url(r'^manage/$', 
        'manage', 
        {'email': None},
        name='newsletters_manage_raw'
    ),
    url(r'^manage/(?P<email>.+)/$', 
        'manage', 
        name='newsletters_manage'
    ),
    url(r'^subscribe/$', 
        'bulk_subscribe', 
        name='newsletters_bulk_subscribe'
    ),
    url(r'^(?P<newsletter_slug>[-\w]+)/$', 
        'detail',
        name="newsletters_detail"
    ),
    url(r'^(?P<newsletter_slug>[-\w]+)/unsubscribe/$', 
        'unsubscribe', 
        name='newsletters_unsubscribe'
    ),
    url(r'^(?P<newsletter_slug>[-\w]+)/is_subscribed/$',
        'is_subscribed',
        name='newsletters_is_subscribed'
    ),
    url(r'^(?P<newsletter_slug>[-\w]+)/subscribe/$', 
        'subscribe', 
        name='newsletters_subscribe'
    ),
)
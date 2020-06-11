from django.conf.urls.defaults import patterns


urlpatterns = patterns(
    'slidey.slideshow.views',
    (r'^$', 'index', None, 'slidey-index'),
    (r'^static/(?P<path>.*)$', 'static', None, 'slidey-static'),
    (r'^(?P<show_id>\d+)/$', 'show'),
    (r'^transform/(?P<item_id>\d+)/$', 'transform'),
    (r'^login/$', 'do_login', None, 'slidey-login'),
    (r'^logout/$', 'do_logout', None, 'slidey-logout'),
    (r'^manage/$', 'manage', None, 'slidey-manage'),
    (r'^show_contents/(?P<show_id>\d+)/$', 'show_contents', None, 'slidey-showcont'),
    (r'^edit/(?P<show_id>\d+)/$', 'edit', None, 'slidey-edit'),
    )

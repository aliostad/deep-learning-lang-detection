from django.conf.urls import url
from . import views

SITE_SLUG = "(?P<site_slug>[-_\w]+)"
IMAGE_SLUG = "(?P<image_slug>[-_\w]+)"

urlpatterns = [
    # Manage
    url(r'^$', views.manage_redirect, name='manage_redirect'),
    url(r'^manage/$', views.manage, name='manage'),
    url(r'^manage/archives$', views.archives, name='archives'),
    url(r'^manage/create/$', views.create, name='create'),
    url(r'^manage/create_js/$', views.create_js, name='create_js'),
    url(r'^manage/' + IMAGE_SLUG + '/trash$', views.trash, name='trash'),
    # View
    url(r'^' + IMAGE_SLUG + '$', views.view),
    url(r'^' + IMAGE_SLUG + '.thumbnail', views.thumbnail),
    url(r'^' + IMAGE_SLUG + '.original', views.original),
]

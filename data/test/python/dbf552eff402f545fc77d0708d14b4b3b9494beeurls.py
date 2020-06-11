# coding:utf-8
# Author:kaidee

from django.conf.urls import *

urlpatterns = patterns(('photos.views'),
	url(r'^photos/$', view = 'gallery_index', name = 'photo_gallery_index'),
	url(r'^photos/newgallery/$', 'add_gallery', name = 'add_gallery'),
	url(r'^photos/upload/$', 'upload_photo', name = 'upload_photo'),
	url(r'^photos/multiupload/(?P<album_id>\d+)/$', 'multi_upload', name = 'multi_upload'),
	url(r'^photos/del/(?P<image_id>\d+)/$', 'del_image', name = 'del_image'),
	url(r'^photos/ajax_del/$', 'ajax_del_image', name = 'ajax_del_image'),
	url(r'^gallery/manage/$', 'manage', name = 'manage'),
	url(r'^gallery/manage/(?P<pk>\d+)/$', 'manage', name = 'manage'),
	url(r'^gallery/del/(?P<pk>\d+)/$', 'gallery_del', name = 'gallery_del'),
	url(r'^gallery/(?P<pk>\d+)/edit/$', 'gallery_edit', name = 'gallery_edit'),
	url(r'^gallery/(?P<id>\d+)/$', 'gallery_view', name = 'gallery_view'),
)
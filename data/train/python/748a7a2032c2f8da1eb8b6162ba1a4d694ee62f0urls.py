from django.conf.urls.defaults import *

urlpatterns = patterns('lfs_gallery.views',

    url(r'^manage/gallery/add/$', "add_gallery", name="add_gallery"),
    url(r'^manage/gallery/(?P<id>\d+)/delete/$', "del_gallery",
        name="del_gallery"),

    url(r'^manage/gallery/item/add/$', "add_gallery_item",
        name="add_gallery_item"),
    url(r'^manage/gallery/item/(?P<id>\d+)/delete/$', "del_gallery_item",
        name="del_gallery_item"),

    url(r'^manage/gallery/$', "manage_galleries",
        name="manage_galleries"),
    url(r'^manage/gallery/(?P<id>\d+)/$', "manage_gallery",
        name="manage_gallery"),
    url(r'^manage/gallery/item/$', "manage_gallery_items",
        name="manage_gallery_items"),
    url(r'^manage/gallery/item/(?P<id>\d+)/$', "manage_gallery_item",
        name="manage_gallery_item"),
)
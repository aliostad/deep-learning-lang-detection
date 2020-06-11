from django.conf.urls import url
from . import views

SITE_SLUG = "(?P<site_slug>[-_\w]+)"
COMIC_SLUG = "(?P<comic_slug>[-_\w]+)"
SLUG = "(?P<slug>[-_\w]+)"

urlpatterns = [
    # View
    url(r'^$', views.home, name='home'),
    url(r'n/(?P<n>[0-9]+)', views.single_by_numerical_order, name='single_by_numerical_order'),
    url(r'c/' + COMIC_SLUG, views.single, name='single'),
    url(r'^manage/' + SITE_SLUG + '/preview/' + COMIC_SLUG, views.preview, name='preview'),

    # Archives
    url(r'^archives$', views.archives, name='archives'),
    url(r'^archives/' + SLUG, views.tag, name='tag'),
    url(r'^search$', views.search, name='search'),

    # Manage Comics
    url(r'^manage/' + SITE_SLUG + '/$', views.manage, name='manage'),
    url(r'^manage/' + SITE_SLUG + '/trash$', views.trash, name='trash'),
    url(r'^manage/' + SITE_SLUG + '/tag/'+ SLUG, views.manage_tag, name='manage_tag'),
    url(r'^manage/' + SITE_SLUG + '/create$', views.create, name='create'),
    url(r'^manage/' + SITE_SLUG + '/update/' + COMIC_SLUG + '/$', views.update, name='update'),
    url(r'^manage/' + SITE_SLUG + '/delete/' + COMIC_SLUG + '/$', views.delete, name='delete'),

    # Blogs
    url(r'^blog$', views.blog, name='blog'),
    url(r'^manage/' + SITE_SLUG + '/update/' + COMIC_SLUG + '/create_blog$', views.create_blog, name='create_blog'),
    url(r'^manage/' + SITE_SLUG + '/update/' + COMIC_SLUG + '/update_blog/' + SLUG, views.update_blog, name='update_blog'),
    url(r'^manage/' + SITE_SLUG + '/update/' + COMIC_SLUG + '/delete_blog/' + SLUG, views.delete_blog, name='delete_blog'),

    # Videos
    url(r'^manage/' + SITE_SLUG + '/update/' + COMIC_SLUG + '/create_video$', views.create_video, name='create_video'),
    url(r'^manage/' + SITE_SLUG + '/update/' + COMIC_SLUG + '/update_video/' + SLUG, views.update_video, name='update_video'),
    url(r'^manage/' + SITE_SLUG + '/update/' + COMIC_SLUG + '/delete_video/' + SLUG, views.delete_video, name='delete_video'),

    # Images
    url(r'^manage/' + SITE_SLUG + '/update/' + COMIC_SLUG + '/create_image$', views.create_image, name='create_image'),
    url(r'^manage/' + SITE_SLUG + '/update/' + COMIC_SLUG + '/update_image/' + SLUG, views.update_image, name='update_image'),
    url(r'^manage/' + SITE_SLUG + '/update/' + COMIC_SLUG + '/delete_image/' + SLUG, views.delete_image, name='delete_image'),
]

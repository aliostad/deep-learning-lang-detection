from django.conf.urls import url
from .views import index
from .views import tag, tag_all, tag_edit, tag_save
from .views import category, category_all, category_edit, category_save
from .views import mylinks, mylinks_all, mylinks_edit, mylinks_save


urlpatterns = [
    url(r'^$', index, name='oadmin_dashboard'),

    url(r'^links/mylinks/$', mylinks, name='oadmin_mylinks'),
    url(r'^links/mylinks/all/$', mylinks_all, name='oadmin_mylinks_all'),
    url(r'^links/mylinks/save/$', mylinks_save, name='oadmin_mylinks_save'),
    url(r'^links/mylinks/(?P<id>[-\w]+)/$', mylinks_edit, name='oadmin_mylinks_edit'),

    url(r'^blog/tag/$', tag, name='oadmin_tag'),
    url(r'^blog/tag/all/$', tag_all, name='oadmin_tag_all'),
    url(r'^blog/tag/save/$', tag_save, name='oadmin_tag_save'),
    url(r'^blog/tag/(?P<id>[-\w]+)/$', tag_edit, name='oadmin_tag_edit'),

    url(r'^blog/category/$', category, name='oadmin_category'),
    url(r'^blog/category/all/$', category_all, name='oadmin_category_all'),
    url(r'^blog/category/save/$', category_save, name='oadmin_category_save'),
    url(r'^blog/category/(?P<id>[-\w]+)/$', category_edit, name='oadmin_category_edit'),
]

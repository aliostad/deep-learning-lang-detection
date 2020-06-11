from django.conf.urls import patterns, include, url

# NOTE: the order matters here.

urlpatterns = patterns('',
    url(r'^manage/mine/$', 'journals.views.mine', name="mine"),
    url(r'^manage/edit/$', 'journals.views.edit', name="edit"),
    url(r'^manage/edit/(?P<id>[\d]+)/$', 'journals.views.edit', name="edit"),
    url(r'^manage/delete/(?P<id>[\d]+)/$', 'journals.views.delete', name="delete"),
    url(r'^view/(?P<journal_id>[0-9]+)/$', 'journals.views.view', name="view"),
    url(r'^view/(?P<username>[0-9a-zA-Z\-]+)/$', 'journals.views.index', name="index"),
    
)

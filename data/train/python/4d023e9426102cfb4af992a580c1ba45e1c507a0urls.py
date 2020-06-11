from django.conf.urls import patterns, url
from map import views


urlpatterns = patterns('',
    url(r'^$', views.index),
    url(r'^overview/', views.overview),
    url(r'^manage-points/', views.managePoints),
    url(r'^submit-point/', views.submitPoint),
    url(r'^delete-point/(\d+)/$', views.deletePoint),
    url(r'^manage-groups/', views.manageGroups),
    #groups
    url(r'^submit-create-group-form/', views.createGroupFormSubmit),
    url(r'^delete-group/(\S+)/$', views.deleteGroup),
    url(r'^add-user-to-group/(\S+)/(\S+)/$', views.addUserToGroup),
    url(r'^remove-user-from-group/(\S+)/(\S+)/$', views.removeUserFromGroup),
)
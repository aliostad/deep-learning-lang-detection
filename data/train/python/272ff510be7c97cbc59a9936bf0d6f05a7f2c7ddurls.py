from django.conf.urls import patterns
from django.conf.urls import url

from openstack_dashboard.dashboards.patch_management.repositories.views \
    import IndexView,CreateRepositoryView,SelectGrainView,RepositoryMembersView


urlpatterns = patterns(
    '',
    url(r'^$', IndexView.as_view(), name='index'),
    url(r'^create$', CreateRepositoryView.as_view(), name='create'),
    url(r'^select_grain$', SelectGrainView.as_view(), name='select_grain'),
    url(r'^(?P<repository_id>[^/]+)/modify_repository_members/$', RepositoryMembersView.as_view(), name='modify_repository_members'),
    
)

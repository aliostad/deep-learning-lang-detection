from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.views.generic import TemplateView
from django.contrib.auth.decorators import login_required, permission_required
from MinecraftGatekeeper.RootSite.views import ProfileView, ManageListView, ManageDetailView, UnsuspendUserView, SuspendUserView, \
    GrantAccessView, RevokeAccessView

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),

    url('', include('social.apps.django_app.urls', namespace='social')),

    url(r'^login/$', TemplateView.as_view(template_name="auth/login.html")),
    url(r'^logout/$', 'MinecraftGatekeeper.RootSite.views.logout', name='logout'),

    url(r'^resources/$', login_required(TemplateView.as_view(template_name="resources.html")), name='resources'),

    url(r'^manage/$', permission_required('RootSite.change_user')(ManageListView.as_view()), name='manage-list'),
    url(r'^manage/(?P<slug>\w+)/$', permission_required('RootSite.change_user')(ManageDetailView.as_view()), name='manage-detail'),
    url(r'^manage/(?P<slug>\w+)/suspend$', permission_required('RootSite.change_user')(SuspendUserView.as_view()), name='suspend-user'),
    url(r'^manage/(?P<slug>\w+)/unsuspend$', permission_required('RootSite.change_user')(UnsuspendUserView.as_view()), name='unsuspend-user'),
    url(r'^manage/(?P<slug>\w+)/grant$', permission_required('RootSite.change_user')(GrantAccessView.as_view()), name='grant-access'),
    url(r'^manage/(?P<slug>\w+)/revoke$', permission_required('RootSite.change_user')(RevokeAccessView.as_view()), name='revoke-access'),

    url(r'^$', login_required(ProfileView.as_view()), name='profile'),
)

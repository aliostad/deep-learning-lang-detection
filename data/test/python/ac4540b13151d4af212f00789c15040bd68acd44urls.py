from django.conf.urls import patterns, url

from stucampus.master.views.manage.account import ListAccount, ShowAccount
from stucampus.master.views.manage.infor import ListInfor, PostInfor
from stucampus.master.views.manage.infor import Information
from stucampus.master.views.manage.organization import ListOrganization
from stucampus.master.views.manage.organization import ShowOrganization
from stucampus.master.views.manage.organization import OrganzationManager
from stucampus.organization.views import EditOrganization


urlpatterns = patterns(
    '',
    url(r'^$', 'stucampus.master.views.manage.index.redirect',
        name='admin_index_redirect'),

    url(r'^index$',
        'stucampus.master.views.manage.index.index', name='admin_index'),

    url(r'^organization/list$', ListOrganization.as_view(),
        name='manage_organization_list'),
    url(r'^organization/(?P<id>\d+)$', ShowOrganization.as_view(),
        name='manage_organization_show'),
    url(r'^organization/(?P<id>\d+)/manager$', OrganzationManager.as_view(),
        name='manage_organization_manage'),

    url(r'^account/list$', ListAccount.as_view(), name='manage_account_list'),
    url(r'^account/(?P<id>\d+)$', ShowAccount.as_view(),
        name='manage_account_show'),

    url(r'^infor/list$', ListInfor.as_view(), name='manage_infor_list'),
    url(r'^infor/post$', PostInfor.as_view(), name='manage_infor_post'),
    url(r'^infor/(?P<id>\d+)$', Information.as_view(),
        name='manage_infor_infor'),

    url(r'^organization$',
        'stucampus.organization.views.organization_manage',
        name='organization_manage'),
    url(r'^organization/(?P<id>\d+)/edit$', EditOrganization.as_view(),
        name='organization_edit'),

)

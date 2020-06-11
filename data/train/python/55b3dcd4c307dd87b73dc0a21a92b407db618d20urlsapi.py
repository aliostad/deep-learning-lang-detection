from .views import (ManageOrganizationList, ManageOrganizationDetail, ManageOrganizationAddressDetail,
                    ManageOrganizationAddressList, ManageOrganizationDocumentList, ManageOrganizationDocumentDetail)
from django.conf.urls import patterns, url, include
from surlex.dj import surl
from .views import OrganizationDetail, OrganizationList

urlpatterns = patterns('',
    url(r'^$', OrganizationList.as_view(), name='organization-list'),
    surl(r'^<pk:#>$', OrganizationDetail.as_view(), name='organization-detail'),
    surl(r'^manage/$', ManageOrganizationList.as_view(), name='manage-organization-list'),
    surl(r'^manage/<pk:#>$', ManageOrganizationDetail.as_view(), name='manage-organization-detail'),

    url(r'^addresses/manage/$', ManageOrganizationAddressList.as_view(), name='manage-organization-address-list'),
    surl(r'^addresses/manage/<pk:#>$', ManageOrganizationAddressDetail.as_view(), name='manage-organization-address-detail'),

    url(r'^documents/manage/$', ManageOrganizationDocumentList.as_view(), name='manage-organization-document-list'),
    surl(r'^documents/manage/<pk:#>$', ManageOrganizationDocumentDetail.as_view(), name='manage-organization-document-detail'),

)

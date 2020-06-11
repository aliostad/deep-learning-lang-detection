from django.conf.urls.defaults import patterns, include, url

urlpatterns = patterns('management.views',
    url(r'^$', 'manage_front', name='manage_front'),
    url(r'^organizations/$', 'manage_organizations', name='manage_organizations'),
    url(r'^organization/create/$', 'create_organization', name='manage.create_organization'),

    url(r'^organization/invitation/(?P<invitation_key>\w+)/$', 'claim_organization_invitation', name='claim_organization_invitation'),
    url(r'^organization/invitation/(?P<invitation_id>\w+)/edit/$', 'edit_organization_invitation', name='edit_organization_invitation'),
    url(r'^organizations/invited/$', 'view_organizations_invited', name='view_organizations_invited'),

    url(r'^organization/(?P<organization_slug>\w+)/edit/$', 'edit_organization', name='edit_organization'),
    
)

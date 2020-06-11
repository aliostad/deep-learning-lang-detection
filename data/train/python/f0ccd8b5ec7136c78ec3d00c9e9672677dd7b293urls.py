from django.conf.urls import include, url
from django.core.urlresolvers import reverse
from django.utils.translation import ugettext_lazy as _
from designsafe.apps.accounts import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^profile/$', views.manage_profile, name='manage_profile'),
    url(r'^profile/edit/$', views.profile_edit, name='profile_edit'),
    url(r'^professional-profile/$', views.manage_pro_profile, name='manage_pro_profile'),
    url(r'^professional-profile/edit$', views.pro_profile_edit, name='pro_profile_edit'),
    url(r'^authentication/$', views.manage_authentication, name='manage_authentication'),
    url(r'^identities/$', views.manage_identities, name='manage_identities'),
    url(r'^licenses/$', views.manage_licenses, name='manage_licenses'),
    url(r'^applications/$', views.manage_applications, name='manage_applications'),
    url(r'^notifications/settings/$', views.manage_notifications, name='manage_notifications'),
    url(r'^register/$', views.register, name='register'),
    url(r'^nees-account/(?:(?P<step>\d+)/)?$', views.nees_migration, name='nees_migration'),
    url(r'^registration-successful/$', views.registration_successful, name='registration_successful'),
    url(r'^password-reset/(?:(?P<code>.+)/)?$', views.password_reset, name='password_reset'),
    url(r'^activate/(?:(?P<code>.+)/)?$', views.email_confirmation, name='email_confirmation'),
    url(r'^departments\.json$', views.departments_json, name='departments_json'),

    url(r'^mailing-list/(?P<list_name>.*)/$', views.mailing_list_subscription,
        name='mailing_list_subscription'),
]


def menu_items(**kwargs):
    if 'type' in kwargs and kwargs['type'] == 'account':
        return [
            {
                'label': _('Manage Account'),
                'url': reverse('designsafe_accounts:index'),
                'children': [],
            },
        ]

from forum.settings.base import Setting, SettingSet
from django.utils.translation import ugettext_lazy as _

API_SET = SettingSet('API', _('API settings'), _("API configuration for OSQA"), 4)

API_USERNAME = Setting('API_USERNAME', 'username', API_SET, dict(
label = _("Basic Auth username"),
help_text = _("Username for API access"),
required = True))

API_PASSWORD = Setting('API_PASSWORD', 'password', API_SET, dict(
label = _("Basic Auth password"),
help_text = _("Password for API access"),
required = True))
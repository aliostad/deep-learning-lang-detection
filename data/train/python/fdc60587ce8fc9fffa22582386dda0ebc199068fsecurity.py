import collections
from pyramid.i18n import TranslationStringFactory

_ = TranslationStringFactory('gathr')

READ = 'read'
WRITE = 'write'
MANAGE = 'manage'
DELETE = 'delete'

READ_ONLY = [READ]
READ_WRITE = [READ, WRITE]
ALL_PERMISSIONS = [READ, WRITE, MANAGE, DELETE]

READERS = 'readers'
WRITERS = 'writers'
MANAGERS = 'managers'

GROUPS = collections.OrderedDict([
    (READERS, {'label': _('Read only'), 'permissions': READ_ONLY}),
    (WRITERS, {'label': _('Read and write'), 'permissions': READ_WRITE}),
    (MANAGERS, {'label': _('Manage'), 'permissions': ALL_PERMISSIONS}),
])

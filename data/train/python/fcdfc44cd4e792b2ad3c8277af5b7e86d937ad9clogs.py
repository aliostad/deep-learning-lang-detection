__author__ = 'zhaolei'
import sys

reload(sys)
sys.setdefaultencoding('utf8')

logs_information = [
    ['create_notice_action', 'Notice Manage', 'add',
     'user %(user)s %(create_at)s create notice', 'false'],
    ['delete_notice_action', 'Notice Manage', 'del',
     'user %(user)s %(create_at)s delete notice', 'false'],
    ['update_notice_action', 'Notice Manage', 'edit',
     'user %(user)s %(create_at)s edit notice', 'false'],
    ['delete_notices', 'Notice Manage', 'del',
     'user %(user)s %(create_at)s batch delete notice', 'false'],
]
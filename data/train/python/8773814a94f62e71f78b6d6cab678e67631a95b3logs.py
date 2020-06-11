__author__ = 'zhaolei'
import sys

reload(sys)
sys.setdefaultencoding('utf8')

logs_information = [
    ['create_user_action', 'User Manage', 'add',
     'user %(user)s %(create_at)s create user', 'false'],
    ['update_user_action', 'User Manage', 'edit',
     'user %(user)s %(create_at)s update user', 'false'],
    ['delete_user_action', 'User Manage', 'del',
     'user %(user)s %(create_at)s delete user', 'false'],
    ['change_user_password_action', 'User Manage', 'edit',
     'user %(user)s %(create_at)s change password', 'false'],
    ['update_user_password_action', 'User Manage', 'edit',
     'user %(user)s %(create_at)s update user password', 'false'],
]
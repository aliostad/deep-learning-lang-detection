__author__ = 'zhaolei'
import sys

reload(sys)
sys.setdefaultencoding('utf8')

logs_information = [

    ['create_securitygroup_action', 'Network Security Manage', 'add',
     'user %(user)s %(create_at)s create securitygroup', 'false'],
    ['delete_securitygroup_action', 'Network Security Manage', 'del',
     'user %(user)s %(create_at)s delete securitygroup', 'false'],
    ['create_securitygrouprules_action', 'Network Security Manage', 'add',
     'user %(user)s %(create_at)s create securitygroup rules', 'false'],
    ['delete_securitygrouprules_action', 'Network Security Manage', 'del',
     'user %(user)s %(create_at)s delete securitygroup rules', 'false'],
]
__author__ = 'zhaolei'
import sys
reload(sys)
sys.setdefaultencoding('utf8')

logs_information = [
    ['create_network_action','Virtual NetWork Manage','add','user %(user)s %(create_at)s create network','false'],
    ['delete_network_action','Virtual NetWork Manage','del','user %(user)s %(create_at)s delete network','false'],
    ['edit_network_action','Virtual NetWork Manage','edit','user %(user)s %(create_at)s edit network','false'],
    ['create_subnet_action','Virtual NetWork Manage','add','user %(user)s %(create_at)s create subnet','false'],
    ['edit_subnet_action','Virtual NetWork Manage','edit','user %(user)s %(create_at)s edit subnet','false'],
    ['delete_subnet_action','Virtual NetWork Manage','del','user %(user)s %(create_at)s delete subnet','false'],
    ['create_port_action','Virtual NetWork Manage','add','user %(user)s %(create_at)s create port','false'],
    ['edit_port_action','Virtual NetWork Manage','edit','user %(user)s %(create_at)s edit port','false'],
    ['delete_port_action','Virtual NetWork Manage','del','user %(user)s %(create_at)s delete port','false'],
]
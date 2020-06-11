__author__ = 'zhaolei'
import sys

reload(sys)
sys.setdefaultencoding('utf8')

logs_information = [
    ['create_image', 'Image Manage', 'add',
     'user %(user)s %(create_at)s create image', 'false'],
    ['delete_image', 'Image Manage', 'del',
     'user %(user)s %(create_at)s delete image', 'false'],
    ['delete_image_batch', 'Image Manage', 'del',
     'user %(user)s %(create_at)s batch delete image', 'false'],
    ['update_image_template', 'Image Manage', 'edit',
     'user %(user)s %(create_at)s edit image', 'false'],
    ['create_image_goto_instance', 'Image Manage', 'add',
     'user %(user)s %(create_at)s start instance', 'false'],
]
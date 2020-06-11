# -*- coding: utf-8 -*-

from django.conf import settings
from django.utils.translation import ugettext as _

from appconf import AppConf

class ManageManageConf(AppConf):

    MAINMENU = None
    #MAINMENU = [{'title': _('Shop'),
    #             'children':
    #               [{'url':'lfs_manage_shop',
    #                 'title': _('Preferences')},
    #               ],
    #            },
    #           ]

    PRODUCT_TABS = None
    #PRODUCT_TABS = ['yandex']

    class Meta:
        prefix = 'lfs_manage'

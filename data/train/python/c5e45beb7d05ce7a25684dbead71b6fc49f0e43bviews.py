# -*- coding: utf-8 -*-

from django.http import HttpResponse
from django.template.loader import render_to_string
from django.utils import simplejson

from lfs_managemanage.conf import settings

def get_config(request):
    items = dict(item for item in settings._wrapped.__dict__.items()
                 if item[0].startswith('LFS_MANAGE'))

    items['LFS_MANAGE_MM_RENDERED'] = render_to_string('manage/mainmenu.html',
                {'menu': items['LFS_MANAGE_MAINMENU']})

    json = simplejson.dumps(items)
    return HttpResponse(json, mimetype='application/json')

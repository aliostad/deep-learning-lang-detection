#from django.conf.urls.defaults import *  #deprecated
from django.conf.urls import *
#from django.conf import settings

urlpatterns = patterns('',
    url(r'(?P<tree_context_path>^|^.*)create/?$',
            'ztreews.view_dispatch.create', name='create'),
    url(r'(?P<tree_context_path>^|^.*)update/?$',
            'ztreews.view_dispatch.update', name='update'),
    url(r'(?P<tree_context_path>^|^.*)delete/?$',
            'ztreews.view_dispatch.delete', name='delete'),
    #url(r'(?P<tree_context_path>^|^.*)auth_list/?$',
    #        'ztree.view_dispatch.auth_list', name='auth_list'),
    url(r'(?P<tree_context_path>^|^.*)list/?$',
            'ztreews.view_dispatch.list', name='list'),
    url(r'(?P<tree_context_path>^|^.*)count/?$',
            'ztreews.view_dispatch.count', name='count'),
    url(r'(?P<tree_context_path>^|^.*)lookup/?$',
            'ztreews.view_dispatch.lookup', name='lookup'),
    url(r'(?P<tree_context_path>^|^.*)lookup_all/?$',
            'ztreews.view_dispatch.lookup_all', name='lookup_all'),
    #url(r'(?P<tree_context_path>^|^.*)auth_search/?$',
    #        'ztree.view_dispatch.auth_search', name='auth_search'),
    url(r'(?P<tree_context_path>^|^.*)search/?$',
            'ztreews.view_dispatch.search', name='search'),
    url(r'(?P<tree_context_path>^|^.*)$',
            'ztreews.view_dispatch.detail', name='detail'),
)

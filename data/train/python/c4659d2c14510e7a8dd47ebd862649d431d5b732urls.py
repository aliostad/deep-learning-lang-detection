# -*- coding: utf-8 -*-
from django.conf.urls.defaults import patterns
from merengue.urlresolvers import merengue_url as url


urlpatterns = patterns('plugins.filebrowser.views',
    url(r'^$', 'repositories', name='filebrowser_repositories'),
    url(r'^(?P<repository_name>[\w-]+)/$', 'root', name='filebrowser_root'),
    url({'en': r'^(?P<repository_name>[\w-]+)/listing/$',
         'es': r'^(?P<repository_name>[\w-]+)/listado/$'},
         'listing', name='filebrowser_root_listing'),
    url({'en': r'^(?P<repository_name>[\w-]+)/listing/(?P<path>.*)$',
         'es': r'^(?P<repository_name>[\w-]+)/listado/(?P<path>.*)$'},
         'listing', name="filebrowser_dir_listing"),
    url({'en': r'^(?P<repository_name>[\w-]+)/download/(?P<path>.*)$',
         'es': r'^(?P<repository_name>[\w-]+)/descargar/(?P<path>.*)$'},
         'download', name='filebrowser_download'),
    url({'en': r'^(?P<repository_name>[\w-]+)/upload/(?P<path>.*)$',
         'es': r'^(?P<repository_name>[\w-]+)/subir/(?P<path>.*)$'},
         'upload', name='filebrowser_upload'),
    url({'en': r'^(?P<repository_name>[\w-]+)/create/folder/(?P<path>.*)$',
         'es': r'^(?P<repository_name>[\w-]+)/crear/carpeta/(?P<path>.*)$'},
         'createdir', name='filebrowser_createdir'),
    url({'en': r'^(?P<repository_name>[\w-]+)/action/(?P<path>.*)$',
         'es': r'^(?P<repository_name>[\w-]+)/accion/(?P<path>.*)$'},
         'action', name='filebrowser_action'),
    url({'en': r'^search/files/$',
         'es': r'^buscar/ficheros/$'},
         'search', name='filebrowser_search'),

    # documents
    url({'en': r'^(?P<repository_name>[\w-]+)/create/document/(?P<path>.*)$',
         'es': r'^(?P<repository_name>[\w-]+)/crear/documento/(?P<path>.*)$'},
         'createdoc', name='filebrowser_createdoc'),
    url({'en': ur'^(?P<repository_name>[\w-]+)/view/document/(?P<doc_slug>[-ÑñáéíóúÁÉÍÓÚ\w]+)/$',
         'es': ur'^(?P<repository_name>[\w-]+)/ver/documento/(?P<doc_slug>[-ÑñáéíóúÁÉÍÓÚ\w]+)/$'},
         'viewdoc', name='filebrowser_viewdoc'),
    url({'en': ur'^(?P<repository_name>[\w-]+)/edit/document/(?P<doc_slug>[-ÑñáéíóúÁÉÍÓÚ\w]+)/$',
         'es': ur'^(?P<repository_name>[\w-]+)/editar/documento/(?P<doc_slug>[-ÑñáéíóúÁÉÍÓÚ\w]+)/$'},
         'editdoc', name='filebrowser_editdoc'),
    url({'en': r'^(?P<repository_name>[\w-]+)/remove/(?P<type>[-\w]+)/attachment/(?P<objId>[-\w]+)/$',
         'es': r'^(?P<repository_name>[\w-]+)/eliminar/(?P<type>[-\w]+)/adjunto/(?P<objId>[-\w]+)/$'},
         'remove_attachment', name='filebrowser_remove_attachment'),
)

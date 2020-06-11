# -*- coding: utf-8 -*-
from django.conf.urls.defaults import patterns, url
from django.conf import settings
from djangopypi.feeds import ReleaseFeed

urlpatterns = patterns("djangopypi.views",
    url(r'^$', "root", name="djangopypi-root"),
    #url(r'^packages/$','packages.index', name='djangopypi-package-index'),
    url(r'^simple/$','packages.simple_index', name='djangopypi-package-index-simple'),
    url(r'^bootstrap/$', 'releases.bootstrap_index', name='djangopypi-bootstrap-index-simple'),
    url(r'^search/$','packages.search',name='djangopypi-search'),
    url(r'^pypi/$', 'root', name='djangopypi-release-index'),
    #url(r'^rss/$', ReleaseFeed(), name='djangopypi-rss'),
    
    url(r'^simple/(?P<package>[\w\d_\.\-]+)/$','packages.simple_details',
        name='djangopypi-package-simple'),
    
    url(r'^pypi/(?P<package>[\w\d_\.\-]+)/$','packages.details',
        name='djangopypi-package'),
    #url(r'^pypi/(?P<package>[\w\d_\.\-]+)/rss/$', ReleaseFeed(),
    #    name='djangopypi-package-rss'),
    url(r'^pypi/(?P<package>[\w\d_\.\-]+)/doap.rdf$','packages.doap',
        name='djangopypi-package-doap'),
    url(r'^pypi/(?P<package>[\w\d_\.\-]+)/manage/$','packages.manage',
        name='djangopypi-package-manage'),
    url(r'^pypi/(?P<package>[\w\d_\.\-]+)/manage/versions/$','packages.manage_versions',
        name='djangopypi-package-manage-versions'),
    
    url(r'^pypi/(?P<package>[\w\d_\.\-]+)/(?P<version>[\w\d_\.\-]+)/$',
        'releases.details',name='djangopypi-release'),
    url(r'^pypi/(?P<package>[\w\d_\.\-]+)/(?P<version>[\w\d_\.\-]+)/doap.rdf$',
        'releases.doap',name='djangopypi-release-doap'),
    url(r'^pypi/(?P<package>[\w\d_\.\-]+)/(?P<version>[\w\d_\.\-]+)/manage/$',
        'releases.manage',name='djangopypi-release-manage'),
    url(r'^pypi/(?P<package>[\w\d_\.\-]+)/(?P<version>[\w\d_\.\-]+)/metadata/$',
        'releases.manage_metadata',name='djangopypi-release-manage-metadata'),
    url(r'^pypi/(?P<package>[\w\d_\.\-]+)/(?P<version>[\w\d_\.\-]+)/files/$',
        'releases.manage_files',name='djangopypi-release-manage-files'),
    url(r'^pypi/(?P<package>[\w\d_\.\-]+)/(?P<version>[\w\d_\.\-]+)/files/upload/$',
        'releases.upload_file',name='djangopypi-release-upload-file'),

    url(
        r'^%s/(?P<path>.*)$' % (settings.DJANGOPYPI_RELEASE_URL.strip('/')),
        'releases.download_dist', {
            'document_root': settings.DJANGOPYPI_RELEASE_UPLOAD_TO
        }, name='djangopypi-download'
    ),
)

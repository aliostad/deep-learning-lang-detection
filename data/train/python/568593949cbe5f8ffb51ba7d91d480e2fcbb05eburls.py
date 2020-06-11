# -*- coding: utf-8 -*-
from django.conf.urls.defaults import patterns, url
from packageindex.feeds import ReleaseFeed

# this regex would match all package names as of 2011-05-15. "?!+&():' " srsly?
#PACKAGE_REGEX = r'(?P<package>[\w\d_\.\-\ \?\!\+\&\(\)\:\']+)'
# but who know what other bright ideas people will come up with. *puke*
PACKAGE_REGEX = r'(?P<package>[^//]+)'
VERSION_REGEX = r'(?P<version>[\w\d_\.\-]+)'

urlpatterns = patterns("packageindex.views",
    url(r'^$', "root", name="packageindex-root"),
    url(r'^packages/$','packages.index', name='packageindex-package-index'),
    url(r'^simple/$','packages.simple_index', name='packageindex-package-index-simple'),
    url(r'^search/$','packages.search',name='packageindex-search'),
    url(r'^pypi/$', 'root', name='packageindex-release-index'),
    url(r'^rss/$', ReleaseFeed(), name='packageindex-rss'),
    
    url(r'^simple/' + PACKAGE_REGEX + r'/$','packages.simple_details',
        name='packageindex-package-simple'),
    
    url(r'^pypi/' + PACKAGE_REGEX + r'/$','packages.details',
        name='packageindex-package'),
    url(r'^pypi/' + PACKAGE_REGEX + r'/rss/$', ReleaseFeed(),
        name='packageindex-package-rss'),    
    url(r'^pypi/' + PACKAGE_REGEX + r'/doap.rdf$','packages.doap',
        name='packageindex-package-doap'),
    url(r'^pypi/' + PACKAGE_REGEX + r'/manage/$','packages.manage',
        name='packageindex-package-manage'),
    url(r'^pypi/' + PACKAGE_REGEX + r'/manage/versions/$','packages.manage_versions',
        name='packageindex-package-manage-versions'),
    
    url(r'^pypi/' + PACKAGE_REGEX + r'/' + VERSION_REGEX + r'/$',
        'releases.details',name='packageindex-release'),
    url(r'^pypi/' + PACKAGE_REGEX + r'/' + VERSION_REGEX + r'/doap.rdf$',
        'releases.doap',name='packageindex-release-doap'),
    url(r'^pypi/' + PACKAGE_REGEX + r'/' + VERSION_REGEX + r'/manage/$',
        'releases.manage',name='packageindex-release-manage'),
    url(r'^pypi/' + PACKAGE_REGEX + r'/' + VERSION_REGEX + r'/metadata/$',
        'releases.manage_metadata',name='packageindex-release-manage-metadata'),
    url(r'^pypi/' + PACKAGE_REGEX + r'/' + VERSION_REGEX + r'/files/$',
        'releases.manage_files',name='packageindex-release-manage-files'),
    url(r'^pypi/' + PACKAGE_REGEX + r'/' + VERSION_REGEX + r'/files/upload/$',
        'releases.upload_file',name='packageindex-release-upload-file'),
)
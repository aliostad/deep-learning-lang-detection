from django.conf.urls.defaults import patterns


urlpatterns = patterns('app.views.api',
    (r'^api/commits/count$', 'commits_count'),
    (r'^api/commits/lines$', 'commits_lines'),
    (r'^api/license$', 'license'),
    (r'^api/line-count$', 'line_count'),
    (r'^api/line-count/python$', 'line_count_python'),
    (r'^api/pep8$', 'pep8'),
    (r'^api/popularity/collaborators$', 'popularity_collaborators'),
    (r'^api/popularity/forks$', 'popularity_forks'),
    (r'^api/popularity/issues$', 'popularity_issues'),
    (r'^api/popularity/watchers$', 'popularity_watchers'),
    (r'^api/pyflakes$', 'pyflakes'),
    (r'^api/readme$', 'readme'),
    (r'^api/setup.py$', 'setup_py'),
    (r'^api/swearing$', 'swearing'),
    (r'^api/tabs-or-spaces$', 'tabs_spaces'),
    (r'^api/distribution/(?P<name>\w+)$', 'distribution'),
    (r'^api/correlate/(?P<x>\w+)/(?P<y>\w+)$', 'correlate'),
    (r'^api/autocomplete$', 'autocomplete'),
)


urlpatterns += patterns('app.views.app',
    (r'^about$', 'about'),
    (r'^contact$', 'contact'),
    (r'^explore$', 'explore'),
    (r'^projects$', 'projects'),
    (r'^projects/(?P<user>[-\w\d]+)/(?P<repo>[-\w\d]+)$', 'repo'),
    (r'^$', 'index'),
)

from django.conf.urls.defaults import *


urlpatterns = patterns(
    'svnlit.views',

    (r'^$',
     'repository_list', None, 'svnlit_repository_list'),

    (r'^(?P<repository_label>[\w-]+):c(?P<content_id>[0-9]+)/(?P<path>.+)$',
     'content', None, 'svnlit_content'),

    (r'^(?P<repository_label>[\w-]+)$',
     'changeset_list', None, 'svnlit_changeset_list'),

    (r'^(?P<repository_label>[\w-]+):diff$',
     'repository_diff', None, 'svnlit_repository_diff'),

    (r'^(?P<repository_label>[\w-]+):r(?P<revision>[0-9]+)$',
     'changeset', None, 'svnlit_changeset'),

    (r'^(?P<repository_label>[\w-]+):r(?P<from_revision>[0-9]+)-r(?P<to_revision>[0-9]+)(?P<path>/.*)$',
     'node_diff', None, 'svnlit_node_diff'),

    (r'^(?P<repository_label>[\w-]+):r(?P<revision>[0-9]+)(?P<path>/.*)$',
     'node', None, 'svnlit_node_revision'),

    (r'^(?P<repository_label>[\w-]+)(?P<path>/.*)$',
     'node', {'revision': None}, 'svnlit_node')
)

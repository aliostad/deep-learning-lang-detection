from django.conf.urls.defaults import *

from vcs import views as v


def j(*parts):
    return r'/'.join(parts) + r'/$'

repository = r'^(?P<repository>[\w-]+)'
branches = r'branches'
branch = r'(?P<branch>[\w-]+)'
commits = r'commits'
commit = r'(?P<commit>\w+)'

urlpatterns = patterns('',
    url(r'^$', v.repository_list, name='vcs-repository-list'),
    url(r'^import/$', v.populate_with_test_fixtures, name='vcs-import'),
    url(j(repository), v.repository_detail, name='vcs-repository-detail'),
    url(j(repository, branches, branch), v.branch_detail,
        name='vcs-branch-detail'),
    url(j(repository, branches, branch, commits, commit), v.commit_detail,
        name='vcs-commit-detail'),
)

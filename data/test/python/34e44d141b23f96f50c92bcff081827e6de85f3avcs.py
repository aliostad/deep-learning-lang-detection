from fabric.api import env, task, local
from quilt import utilities


@task
def clone():
    utilities.notify(u'Now cloning from the remote repository.')

    local('git clone ' + env.repository_location + ' .')
    local('git checkout ' + env.repository_branch)


@task
def fetch():
    utilities.notify(u'Now fetching from the remote repository.')

    local('git fetch')


@task
def merge():
    utilities.notify(u'Now merging from the remote repository.')

    local('git merge ' + env.repository_branch + ' origin/' + env.repository_branch)
    local('git checkout ' + env.repository_branch)

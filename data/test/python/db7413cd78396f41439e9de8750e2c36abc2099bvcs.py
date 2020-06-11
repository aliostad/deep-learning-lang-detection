from fabric.api import env, prefix, task, roles, run
from quilt import utilities


@roles('app')
@task
def clone():
    utilities.notify(u'Now cloning from the remote repository.')

    with prefix(env.workon):
        run('git clone ' + env.repository_location + ' .')
        run('git checkout ' + env.repository_branch)
        run(env.deactivate)


@roles('app')
@task
def fetch():
    utilities.notify(u'Now fetching from the remote repository.')

    with prefix(env.workon):
        run('git fetch')
        run(env.deactivate)


@roles('app')
@task
def merge():
    utilities.notify(u'Now merging from the remote repository.')

    with prefix(env.workon):
        run('git merge ' + env.repository_branch + ' origin/' + env.repository_branch)
        run('git checkout ' + env.repository_branch)
        run(env.deactivate)

from fabric.api import *
from fabric.contrib.files import *
from path import path as ppath

app = env.app = {
    'live_catalogue-repo': 'https://svn.eionet.europa.eu/repositories/Python/flis.live_catalogue',
    'localrepo': ppath(__file__).abspath().parent.parent,
}

try: from localcfg import *
except: pass

app.update({
    'instance_var': app['repo']/'instance',
    'manage_var': app['repo']/'live_catalogue',
    'live_catalogue_var': app['repo']/'live_catalogue'/'live_catalogue',
    'sandbox': app['repo']/'sandbox',
    'user': 'edw',
})


@task
def ssh():
    open_shell("cd '%(repo)s'" % app)


def _install_random_key(remote_path, key_length=20, mode=0600):
    import random
    import string
    from StringIO import StringIO
    vocabulary = string.ascii_letters + string.digits
    key = ''.join(random.choice(vocabulary) for c in xrange(key_length))
    put(StringIO(key), remote_path, mode=mode)


def _svn_repo(repo_path, origin_url, update=True):
    if not exists(repo_path/'.svn'):
        run("mkdir -p '%s'" % repo_path)
        with cd(repo_path):
            run("svn co '%s' ." % origin_url)

    elif update:
        with cd(repo_path):
            run("svn up")

@task
def install_live_catalogue():
    _svn_repo(app['repo'], app['live_catalogue-repo'], update=True)

    if not exists(app['sandbox']):
        run("virtualenv --distribute '%(sandbox)s'" % app)
    run("%(sandbox)s/bin/pip install -r %(repo)s/requirements.txt" % app)

    if not exists(app['manage_var']/'media'):
        run("mkdir -p '%(manage_var)s/media'" % app)
    if not exists(app['instance_var']):
        run("mkdir -p '%(instance_var)s'" % app)
    if not exists(app['instance_var']/'files'):
        run("mkdir -p '%(instance_var)s/files'" % app)

    secret_key_path = app['instance_var']/'secret_key.txt'
    if not exists(secret_key_path):
        _install_random_key(str(secret_key_path))

    #put(app['localrepo']/'fabfile'/'production-settings.py',
    #    str(app['live_catalogue_var']/'local_settings.py'))

    upload_template(app['localrepo']/'fabfile'/'supervisord.conf',
                    str(app['sandbox']/'supervisord.conf'),
                    context=app, backup=False)

    run("%s/bin/python %s/manage.py syncdb" % (app['sandbox'], app['manage_var']))
    run("%s/bin/python %s/manage.py migrate" % (app['sandbox'], app['manage_var']))
    run("%s/bin/python %s/manage.py loaddata initial_categories" % (app['sandbox'], app['manage_var']))
    run("%s/bin/python %s/manage.py loaddata initial_flis_topics" % (app['sandbox'], app['manage_var']))
    run("%s/bin/python %s/manage.py loaddata initial_themes" % (app['sandbox'], app['manage_var']))

    run("%s/bin/python %s/manage.py collectstatic --noinput" % (app['sandbox'], app['manage_var']))

@task
def live_catalogue_supervisor():
    run("'%(sandbox)s/bin/supervisord'" % {
            'sandbox': app['sandbox'],
        })

@task
def update_live_catalogue():
    _svn_repo(app['repo'], app['live_catalogue-repo'], update=True)

    if not exists(app['sandbox']):
        run("virtualenv --distribute '%(sandbox)s'" % app)
    run("%(sandbox)s/bin/pip install -r %(repo)s/requirements.txt" % app)

    if not exists(app['manage_var']/'media'):
        run("mkdir -p '%(manage_var)s/media'" % app)
    if not exists(app['instance_var']):
        run("mkdir -p '%(instance_var)s'" % app)
    if not exists(app['instance_var']/'files'):
        run("mkdir -p '%(instance_var)s/files'" % app)

    #put(app['localrepo']/'fabfile'/'production-settings.py',
    #    str(app['live_catalogue_var']/'local_settings.py'))

    upload_template(app['localrepo']/'fabfile'/'supervisord.conf',
                    str(app['sandbox']/'supervisord.conf'),
                    context=app, backup=False)

    run("%s/bin/python %s/manage.py syncdb" % (app['sandbox'], app['manage_var']))
    run("%s/bin/python %s/manage.py migrate" % (app['sandbox'], app['manage_var']))
    run("%s/bin/python %s/manage.py loaddata initial_categories" % (app['sandbox'], app['manage_var']))
    run("%s/bin/python %s/manage.py loaddata initial_flis_topics" % (app['sandbox'], app['manage_var']))
    run("%s/bin/python %s/manage.py loaddata initial_themes" % (app['sandbox'], app['manage_var']))

    run("%s/bin/python %s/manage.py collectstatic --noinput" % (app['sandbox'], app['manage_var']))

    execute('service_live_catalogue', 'restart')


@task
def service_live_catalogue(action):
    run("'%(sandbox)s/bin/supervisorctl' %(action)s %(name)s" % {
            'sandbox': app['sandbox'],
            'action': action,
            'name': 'live_catalogue',
        })

@task
def deploy_live_catalogue():
    execute('install_live_catalogue')
    execute('live_catalogue_supervisor')
    execute('service_live_catalogue', 'restart')


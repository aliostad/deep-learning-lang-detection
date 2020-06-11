# -*- coding: utf-8 -*-
from fabric.api import env, cd, run, prefix
from fabric.operations import local
from videoad.settings import LOCAL_APPS

env.hosts = ['videoad@videoad.ru:22']
prefix = prefix('source /home/videoad/bin/activate')

def deploy():
    with cd('/home/videoad/site/videoad'):
        with prefix:
            run('hg pull -u -b default')
            run('pip install -r deps.pip')
            run('python ./manage.py syncdb')
            run('python ./manage.py migrate')
            run('python ./manage.py collectstatic --noinput')
            run('touch videoad/wsgi.py')

def manage(command='help'):
    with cd('/home/videoad/site/videoad'):
        with prefix:
            run('python ./manage.py %s' % command)

def migrate():
    for app in LOCAL_APPS:
        try:
            local('python manage.py schemamigration {app} --auto'.format(app=app), capture=False)
        except :
            pass
    local('python manage.py migrate', capture=False)

def syncdb():
    local('python manage.py syncdb --noinput --migrate')
    local('python manage.py loaddata initial_data.json')

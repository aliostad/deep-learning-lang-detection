# -*- coding: utf-8 -*-
from fabric.api import env, cd, run, prefix
from fabric.operations import local
from ovz.settings import LOCAL_APPS

env.hosts = ['ovz@allsol.ru:7626']
prefix = prefix('source /home/ovz/bin/activate')


def deploy():
    local('git push')
    with cd('/home/ovz/site/ovz'):
        with prefix:
            run('git pull')
            run('pip install -r requirements.txt')
            run('python ./manage.py syncdb')
            run('python ./manage.py migrate')
            run('python ./manage.py collectstatic --noinput')
    run('./restart.sh')


def manage(command='help'):
    with cd('/home/ovz/site/ovz'):
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

from fabric.api import run, put, sudo, env, cd, local
import os

env.hosts = ['example.com']
env.user = 'django'
env.base_dir = '/www/support-chat/'


def _manage(command):
    run('%senv/bin/python %ssupport_site/manage.py %s' % (env.base_dir, env.base_dir, command))


def stage():
    with cd(env.base_dir):
        run('git pull origin master')
        run('find . -name "*.pyc" -exec rm {} \;')
        _manage('reset_staging')
        _manage('collectstatic --noinput')
        run('touch support_site/django.wsgi')
        run('supervisorctl restart all')

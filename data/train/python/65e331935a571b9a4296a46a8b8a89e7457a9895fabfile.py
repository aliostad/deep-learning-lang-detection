from fabric.api import run, env
from fabric.context_managers import cd
import os

env.roledefs = {
    'local': ['root@0.0.0.0:1337'],
    'server': ['root@188.226.173.220'],
}


def update_podcasts():
    with cd('"{}"'.format(os.path.dirname(__file__))):
        run('python3 manage.py updatepodcasts')


def fetch_episodes():
    with cd('"{}"'.format(os.path.dirname(__file__))):
        run('python3 manage.py fetchepisodes')


def setup_dev():
    run('/etc/init.d/postgresql start')
    with cd('"{}"'.format(os.path.dirname(__file__))):
        run('python3 manage.py syncdb')
        run('python3 manage.py loaddata sample_podcasts')
        run('python3 manage.py updatepodcasts')
        run('python3 manage.py fetchepisodes')
        run('python3 manage.py update_index')


def setup_server():
    with cd('/sputnik'):
        run('python3 manage.py syncdb')
        run('python3 manage.py loaddata sample_podcasts')
        run('python3 manage.py updatepodcasts')
        run('python3 manage.py fetchepisodes')
        run('python3 manage.py update_index')


def rebuild_index():
    with cd('"{}"'.format(os.path.dirname(__file__))):
        # Add --noinput flag because of this issue:
        # https://github.com/toastdriven/django-haystack/issues/902
        run('python3 manage.py rebuild_index --noinput')

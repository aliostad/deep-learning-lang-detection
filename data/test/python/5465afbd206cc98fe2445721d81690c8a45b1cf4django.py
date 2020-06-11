from contextlib import contextmanager
from fabric.api import env, run, task, cd
from fabric.network import needs_host
from .virtualenv import virtualenv


@needs_host
def django_command(*args):
    if hasattr(env, 'DJANGO_MANAGE_PATH'):
        MANAGE_PATH  = env.DJANGO_MANAGE_PATH
    else:
        # Use django 1.4 default type path to manage.py
        MANAGE_PATH = env.PROJECT_PATH
    with cd(MANAGE_PATH):
        with virtualenv():
            # arg is just a tuple.
            full_command = ' '.join(args)
            run('python manage.py %s' % full_command)

@task
def collectstatic():
    django_command('collectstatic', '--noinput')


@task
def migrate():
    django_command('migrate')


@task
def syncdb():
    django_command('syncdb')

"""
    Helper function for django projects
    Requires using virtualenv and project helpers
"""
from fabric.api import sudo, run
from fabric.decorators import task

from project import in_project
from virtualenv import venv


def django_env(command, use_sudo=False):
    """
        run command in django environment
    """
    func = use_sudo and sudo or run

    with venv():
        with in_project():
            func(command)


def django_manage(manage_command, use_sudo=False):
    """
        run django managment commands
    """
    command = 'python manage.py %s' % manage_command
    django_env(command, use_sudo)


@task
def django_syncdb(use_sudo=False):
    """
        Run python manage.py syncdb --no-input
    """
    django_manage('syncdb --noinput', use_sudo)


@task
def django_migration(use_sudo=False):
    """
        Run python manage.py migrate --no-input
    """
    django_manage('migrate --noinput', use_sudo)


@task
def django_collectstatic(use_sudo=False):
    """
        Run python manage.py collectstatic --no-input
    """
    django_manage('collectstatic --noinput', use_sudo)


@task
def django_cleanpyc(use_sudo=False):
    """
        Run python manage.py cleanpyc
    """
    func = use_sudo and sudo or run
    with in_project():
        func("find . -name '*.pyc' -delete")

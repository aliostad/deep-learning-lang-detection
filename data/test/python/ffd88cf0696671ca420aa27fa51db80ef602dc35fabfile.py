"""
Common routines functions
"""
from fabric.api import local
from fabric.contrib import django
from fabric.colors import red

# sets up DJANGO_SETTINGS_MODULE
django.settings_module('weblines.settings.dev')
from django.conf import settings

# extract self-written apps
app_paths = filter(lambda x: x.startswith('weblines'), settings.INSTALLED_APPS)
apps = map(lambda x: x.split('.')[-1], app_paths)


def _manage(command, settings='weblines.settings.dev'):
    """
    Runs manage.py with given parameters

    Arguments:
    - `command`: command to execute
    - `settings`: settings to use (defaults to development)
    """
    local('python manage.py %s --settings=%s' % (command, settings))


def dev_initdb():
    """
    Initializes development database and performs initial migrations
    """
    for app in apps:
        _manage('schemamigration --initial %s' % app)

    _manage('syncdb --migrate')


def dev_migrate(*apps):
    """
    Migrates given applications (development)

    Arguments:
    - `apps`: applications to migrate
    """
    for app in apps:
        try:
            _manage('schemamigration --auto %s' % app)
            _manage('migrate %s' % app)
        except:
            print red('Failed to migrate %s app!' % app)


def prod_initdb():
    """
    Initializes production database and performs initial migrations
    """
    settings = 'weblines.settings.prod'

    for app in apps:
        _manage('schemamigration --initial %s' % app, settings)

    _manage('syncdb --migrate', settings)


def prod_migrate(*apps):
    """
    Migrates given applications (development)

    Arguments:
    - `apps`: applications to migrate
    """
    for app in apps:
        try:
            settings = 'weblines.settings.prod'
            _manage('schemamigration --auto %s' % app, settings)
            _manage('migrate %s' % app, settings)
        except:
            print red('Failed to migrate %s app!' % app)


def test():
    """
    Executes module tests
    """
    _manage('test')


def run():
    """
    Starts the development server
    """
    _manage('runserver')

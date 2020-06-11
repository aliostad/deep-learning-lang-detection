
import os
from fabric.api import local, settings, hide

PROJECT_ROOT = os.path.dirname(__file__)


def manage(command='help'):
    local("python src/{{ project_name }}/manage.py %s" % command)


def run():
    manage('runserver 0.0.0.0:8000')


def runplus():
    manage('runserver_plus 0.0.0.0:8000')


def shell():
    manage('shell_plus')


def syncdb(options='--migrate'):
    manage('syncdb %s' % options)


def migration(app, options='--auto'):
    manage('schemamigration %s %s' % (app, options))


def migrate(options=''):
    manage('migrate %s' % options)


def buildstatic():
    manage('collectstatic -v0 --noinput')


def test(options='', settings='baseapp.settings.test'):
    manage('test %s --settings=%s' % (options, settings))


def thumbor():
    local('thumbor --conf=develop/conf/thumbor.conf --port=8001')


def less():
    main_less = os.path.join(PROJECT_ROOT, 'src', '{{ project_name }}',
                             'baseapp', 'static', 'less', 'main.less')
    local('python develop/bin/watchless.py %s' % main_less)


def clear_pyc():
    local('find -name "*.pyc" -delete')


def celery():
    with _quiet():
        local('python src/{{ project_name }}/manage.py celerycam '
              '--pidfile=var/run/celeryev.pid &')
    local('python src/{{ project_name }}/manage.py celery worker '
          '-E -B -l INFO --autoreload --schedule=var/run/celerybeat-schedule')


def setup():
    if os.path.exists('README.tpl'):
        local('mv README.tpl README.md')
    local('rm -f LICENSE')
    local('mkdir -p var/log')
    local('mkdir -p var/media')
    local('mkdir -p var/run')
    local('mkdir -p var/static')
    local('mkdir -p var/temp')
    local('pip install -r requirements/develop.txt')
    syncdb('--migrate')


_quiet = lambda: settings(hide('everything'), warn_only=True)

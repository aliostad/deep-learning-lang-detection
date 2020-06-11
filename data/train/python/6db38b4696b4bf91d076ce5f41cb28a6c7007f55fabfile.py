"""Fabric configurations file."""

from fabric.api import local

SETTINGS = {
    "TEST_PROCESS_TIMEOUT": 30,
    "TEST_PROCESSES_COUNT": -1,
    "TEST_LIVESERVER_PORT": "8081-9081",
    "TEST_PACKAGES": ",".join([
        'metrics',
        'comment',
        'faker',
        'post',
        'page',
        'rblog'])}


def clean():
    local('find . -name "*.pyc" -delete')
    local("rm -rf cover/")
    local("rm -f .coverage")


def deploy():
    local("pip install -r requirements.txt")
    local("python manage.py migrate")


def runserver():
    local("python manage.py runserver 127.0.0.1:8000")


def setup():
    local("pip install -r requirements.txt")
    local("python manage.py syncdb")
    local("python manage.py migrate")
    local("python manage.py populatedb")


#------------------------------------------------------------------------------
# testing

def coverage():
    local((
        "python manage.py test"
        " --with-coverage"
        " --cover-html"
        " --cover-package=%(TEST_PACKAGES)s"
        " --nocapture" % SETTINGS))


def test():
    local((
        "python manage.py test"
        " --processes=%(TEST_PROCESSES_COUNT)d"
        " --nocapture" % SETTINGS))

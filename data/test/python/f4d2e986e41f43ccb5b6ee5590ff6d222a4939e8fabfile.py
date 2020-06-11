from __future__ import with_statement
from fabric.api import *

env.host_string = 'vagrant@33.33.33.10'

def add(app_name):
    local('python manage.py startapp %s' % app_name)

def db():
    with cd('/vagrant/markpro'):
        run('python manage.py syncdb')

def shell():
    with cd('/vagrant/markpro'):
        run('python manage.py shell')

def vagrant():
    cmd = raw_input().strip()
    with cd('/vagrant/markpro'):
        run('python manage.py ' + cmd)

def reload():
    run('sudo /etc/init.d/apache2 restart')

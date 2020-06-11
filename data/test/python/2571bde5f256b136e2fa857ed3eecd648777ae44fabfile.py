import os, json
from tempfile import mkdtemp
from contextlib import contextmanager

from fabric.operations import put
from fabric.api import env, local, sudo, run, cd, prefix, task, settings, execute
from fabric.colors import green as _green, yellow as _yellow, red as _red
from fabric.context_managers import hide, show, lcd

#-----FABRIC TASKS-----------

@task
def rs():
	local("python manage.py runserver 0.0.0.0:8000")

@task
def resetdb():
	local("rm db.sqlite3")
	local("./manage.py syncdb --noinput")
	local("./manage.py createsuperuser --username=jason --email=jason@rootid.in")

@task
def dumpdata():
	local("./manage.py dumpdata -n quote > quote.json")

@task 
def loaddata():
	local("./manage.py loaddata quote.json")
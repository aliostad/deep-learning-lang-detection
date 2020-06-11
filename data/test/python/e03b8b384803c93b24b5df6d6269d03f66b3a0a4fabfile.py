# coding: utf-8
from __future__ import with_statement
from functools import partial
import os, os.path, time
import functools

from fabric.api import *
from fabric.contrib.files import append, exists, comment, contains
from fabric.contrib.files import upload_template as orig_upload_template

# Debug mode
env.abort_on_prompts = True
from fabric.api import local as run


import inspect
def s(template, **kwargs):
    '''Usage: s(string, **locals())'''
    if not kwargs:
        frame = inspect.currentframe()
        try:
            kwargs = frame.f_back.f_locals
        finally:
            del frame
        if not kwargs:
            kwargs = globals()
    return template.format(**kwargs)


def colorize(message, color='blue'):
  color_codes = dict(black=30, red=31, green=32, yellow=33, blue=34, magenta=35, cyan=36, white=37)
  code = color_codes.get(color, 34)
  msg =  s('\033[{code}m{message}\033[0m')
  # print(msg)
  return msg


def run_on_virtual_env(command, env='env'):
  run(s('source {env}/bin/activate && {command}'))


@task
def bootstrap():
    local("virtualenv env -p pypy")
    run_on_virtual_env("pip install -r requirements.txt", "env")
    run_on_virtual_env("pip freeze > requirements.txt.lock", "env")
    run_on_virtual_env("pip install -r requirements-dev.txt", "env")
    run_on_virtual_env("python manage.py migrate", "env")
    run_on_virtual_env("python manage.py createsuperuser")
    run_on_virtual_env("python manage.py runserver", "env")
    # virtual_env("sudo python manage.py runserver 0.0.0.0:80")


@task
def check():
    run_on_virtual_env('python manage.py check')
    run_on_virtual_env('python manage.py validate')
    run_on_virtual_env('python manage.py validate_templates')
    run_on_virtual_env('python manage.py test')
    run_on_virtual_env('python manage.py test_coverage')
    run_on_virtual_env('tox')
    run_on_virtual_env('python manage.py graph_models')


@task
def deploy():
    check()
    run_on_virtual_env('python manage.py clean_pyc')
    run_on_virtual_env('python manage.py compile_pyc')
    run_on_virtual_env('python manage.py makemessages')
    run_on_virtual_env('python manage.py compilemessages')
    run_on_virtual_env('python manage.py collectstatic --noinput')
    run_on_virtual_env('python manage.py migrate')


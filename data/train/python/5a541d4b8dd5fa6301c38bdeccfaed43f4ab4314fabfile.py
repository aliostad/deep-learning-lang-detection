# -*- coding:utf-8 -*-
__author__ = 'michael'

from fabric.api import *


def django_manage(command='help'):
    return "/bin/bash -l -c 'cd /home/michael/work/sites/helpdesk && source env/bin/activate  && python project/manage.py %s'" % (command,)


def syncdb():
    local(django_manage('syncdb'))


def startData():
    local(django_manage('runscript startData'))


def startDataLocal():
    local(django_manage('runscript startDataLocal'))


def full_reset():
    syncdb()
    startData()
    startDataLocal()



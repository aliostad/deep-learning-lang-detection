from __future__ import with_statement
from fabric.api import settings, abort, run, cd, local
from fabric.contrib.console import confirm

def prepare_deploy():
    local("./manage.py test")
    local("git add -p && git commit")

def initial_setup():
    local("python manage.py syncdb")
    local("python manage.py migrate")
    local("python manage.py get_poems")

def deploy(server='dev'):
    if server == 'dev':
        code_dir = 'path/to/code/dir'
        git = "sudo git pull origin master"
    with cd(code_dir):
        run(git)
        run("./manage.py syncdb")
        run("./manage.py migrate")
        sudo("/etc/init.d/httpd restart")
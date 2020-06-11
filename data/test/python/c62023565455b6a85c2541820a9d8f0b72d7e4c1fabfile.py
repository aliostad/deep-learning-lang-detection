from fabric.api import lcd, local

DEPLOY_DIR = '<PRODUCTION_DIR>'
DEV_DIR = '<DEV_DIR>'
APPS = []

def manage_apps(command):
    for app in APPS:
        local('python manage.py {} {}'.format(command, app))

def merge_to_master(branch_name):
    local('git add -p && git commit')
    local('git checkout master && git merge {}'.format(branch_name))
    local('git checkout {}'.format(branch_name))

def prepare_deployment(branch_name):
    manage_apps('test')
    merge_to_master(branch_name)

def deploy():
    with lcd(DEPLOY_DIR):
        local('git pull {}'.format(DEV_DIR))
        manage_apps('migrate')
        local('python manage.py collectstatic -v0 --noinput')
        manage_apps('test')

def qd(branch_name):
    prepare_deployment(branch_name)
    deploy()


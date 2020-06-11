from fabric.api import cd, env, require, run, sudo, task
from fabric.contrib.files import exists


@task
def manage(command, manage='manage.py', envdir='env'):
    """Run a django management command. e.g. deploy.manage:syncdb"""
    require('site_path')
    with cd(env.site_path):
        cmd = './bin/python {0} {1}'.format(manage, command)
        if envdir:
            cmd = 'envdir {0} {1}'.format(envdir, cmd)
        run(cmd)


@task
def pip(requirements_file='requirements.txt'):
    """Run pip install."""
    require('site_path')
    with cd(env.site_path):
        if exists(requirements_file):
            run('./bin/pip install -r {0}'.format(requirements_file))


@task
def pull():
    """Run git pull."""
    require('site_path')
    with cd(env.site_path):
        run('git pull')


@task
def supervisor(command):
    """Run a supervisorctl command. e.g. deploy.supervisor:'restart all'"""
    sudo('supervisorctl {0}'.format(command), shell=False)


@task
def update():
    """Update the site folder."""
    pull()
    pip()
    manage('syncdb')
    manage('migrate')
    manage('collectstatic --noinput')
    supervisor('restart all')

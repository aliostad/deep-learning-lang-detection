from fabric.decorators import task
from fabric.context_managers import settings
from fabric.api import require, env, local, abort, run as frun
from fabric.contrib.console import confirm
from fabric.colors import green, red


@task
def build():
    """
    Build project environment.
    """
    stage('Updating virtual environment...')
    do('[ -d venv ] || virtualenv venv --no-site-packages --python=python2.7')
    do('venv/bin/pip install --upgrade -r requirements.txt')

    stage('Update assets...')
    manage('compilemessages')
    manage('collectstatic --noinput -v 0')

    stage('Updating database...')
    manage('syncdb --noinput')
    manage('migrate --noinput')
    manage('check_permissions')  # userena fix


@task
def r(cmd="127.0.0.1:8000"):
    """
    Start project in debug mode (for development).
    """
    manage('runserver_plus {0}'.format(cmd))

@task
def run(cmd="127.0.0.1:8000"):
    """
    Start project in debug mode (for development).
    """
    manage('runserver {0}'.format(cmd))


@task
def manage(cmd):
    """
    Run django manage `cmd`
    """
    return do('venv/bin/python ./manage.py {0}'.format(cmd))


@task
def test(cmd='--noinput'):
    return manage('test {0}'.format(cmd))


def stage(message):
    """
    Show `message` about current stage
    """
    print(green("\n *** {0}".format(message), bold=True))


def do(*args):
    """
    Runs command locally or remotely depending on whether a remote host has
    been specified and ask about continue on fail.
    """
    with settings(warn_only=True):
        if env.host_string:
            with settings(cd(config.remote_path)):
                result = frun(*args, capture=False)
        else:
            result = local(*args, capture=False)

    if result.failed:
        if result.stderr:
            print(red(result.stderr))
        if not confirm("Continue anyway?"):
            abort('Stopped execution per user request.')

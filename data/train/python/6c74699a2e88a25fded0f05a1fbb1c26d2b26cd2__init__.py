from fabric.api import local, task, sudo
import css, heroku

@task
def run():
    local("ps ax | grep [s]ocketio | awk '{ print $1 }' | sudo xargs kill -9")
    local('sudo python manage.py runserver_socketio 0.0.0.0:80')

@task
def run_server_only():
    local('python manage.py runserver [::]:8000')

@task
def reset():
    local('rm -f sqlite.db')
    local('python manage.py syncdb --noinput')
    local('python manage.py createsuperuser --username=user --email=user@host.com')


@task
def celery():
	local('python manage.py celeryd worker --loglevel=INFO')
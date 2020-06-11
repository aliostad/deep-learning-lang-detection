#from fabric_heroku_postgresql.core import *
from fabric.api import local, env, require

def resetdb():
  local('rm -f rocket/default.db')
  local('python manage.py syncdb --noinput --migrate')
  local('python manage.py loaddata messages_demo.yaml')
  local('python manage.py rebuild_index --noinput')

def deploy():
    """fab [environment] deploy"""

    # require('AWS_KEY')
    # require('AWS_SECRET')
    # require('AWS_STORAGE_BUCKET_NAME')
    # require('HEROKU_APP')

    local('heroku maintenance:on')
    local('DJANGO_SETTINGS_MODULE=rocket.settings.staging python manage.py collectstatic --noinput')
    local('git push heroku HEAD:master')
    local('heroku run python manage.py syncdb --noinput')
    local('heroku run python manage.py migrate')
    local('heroku run python manage.py collectstatic --noinput')
    local('heroku maintenance:off')
    local('heroku ps')
    local('heroku open')

def deploy_staging():
  local('heroku maintenance:on --app rocket-listings-staging')
  local('DJANGO_SETTINGS_MODULE=rocket.settings.staging python manage.py collectstatic --noinput')
  local('git push --force staging HEAD:master')
  local('heroku run python manage.py syncdb --noinput --app rocket-listings-staging')
  local('heroku run python manage.py migrate --app rocket-listings-staging')
  local('heroku run python manage.py collectstatic --noinput --app rocket-listings-staging')
  local('heroku maintenance:off --app rocket-listings-staging')
  local('heroku ps --app rocket-listings-staging')

def test_local():
  local("casperjs test tests --url=http://localhost:8000")

def test_staging():
  local("casperjs test tests --url=http://rocket-listings-staging.herokuapp.com/")

def test_production():
  local("casperjs test tests --url=http://beta.rocketlistings.com/")

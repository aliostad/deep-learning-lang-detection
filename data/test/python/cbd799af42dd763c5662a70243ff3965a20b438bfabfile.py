from fabric.api import local

def deploy_party(party, collectstatic):
    local('git push %s master' % party)
    local('heroku run --app %s python manage.py syncdb --migrate' % party)
    if collectstatic:
        local('heroku run --app %s python manage.py collectstatic --noinput' % party)

def deploy(collectstatic=False):
    for party in ('likud', 'havoda'):
        deploy_party(party, collectstatic)

def runserver():
    local('python manage.py collectstatic --noinput')
    local('python manage.py runserver')

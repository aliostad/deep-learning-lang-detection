from fabric.api import local, lcd
    
apps = ('article',)

def prepare_deployment(branch_name):
    print 'preparing deployment for %s' % branch_name
    for appname in apps:
        local('python manage.py test %s' % appname)
    local('git add -p && git commit')
    local('git checkout master && git merge %s' % branch_name)
    
def deploy():
    with lcd('~/Documents/crimsonbeacon/crimsonbeacon'):
        local('git pull ~/Documents/crimsonbeacon/dev')
        for appname in apps:
            local('python manage.py migrate %s' % appname)
            local('python manage.py test %s' % appname)
        local('python manage.py runserver')
        
from fabric.api import local

def prepare_deployment():
    local('python neighborhood/manage.py test hoods --settings=neighborhood.settings.local')
    local('git add -A && git commit')
    local('git push origin master')
    
def migrate_local():
    local('python neighborhood/manage.py syncdb --settings=neighborhood.settings.local')
    local('python neighborhood/manage.py migrate data --settings=neighborhood.settings.local')
    local('python neighborhood/manage.py migrate hoods --settings=neighborhood.settings.local')

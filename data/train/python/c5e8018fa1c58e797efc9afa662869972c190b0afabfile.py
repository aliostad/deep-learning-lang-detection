from fabric.api import local

def remove_pyc():
    local('find . -name "*.pyc" -exec rm -rf {} \;')

def test_cover(integration=1):
    local('python manage.py test -v 2 --settings=meadowlark.test_settings --with-coverage --cover-html --cover-package=meadowlark')

def test():
    local('python manage.py test -v 2 --settings=meadowlark.test_settings')

def test_travis():
	local('python manage.py test -v 2 --settings=meadowlark.travis_settings')

def runserver():
	local('python manage.py runserver --settings=meadowlark.development_settings')
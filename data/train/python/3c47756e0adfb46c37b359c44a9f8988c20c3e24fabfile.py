from fabric.api import local


def start():
    local('python manage.py runserver 0.0.0.0:8000')


def static():
    local('python manage.py collectstatic')


def change():
    local('python manage.py makemigrations')


def migrate():
    local('python manage.py migrate')


def savetree():
    local('python manage.py sitetreedump > fixtures/treedump.json')


def loadtree():
    local('python manage.py sitetreeload --mode=replace fixtures/treedump.json')


def install():
    migrate()
    loadtree()
    local('python manage.py createsuperuser --username root --email root@root.com')

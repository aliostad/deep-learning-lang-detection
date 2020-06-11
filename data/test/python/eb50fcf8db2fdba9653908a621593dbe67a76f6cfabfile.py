"""
To use this, you need to install Fabric3
http://www.fabfile.org/installing.html
"""
from fabric.api import local


def runserver():
    """
    Run Django development sever
    """
    local('python manage.py runserver')


def makemigr():
    """
    Create migrations after models changing
    """
    local('python manage.py makemigrations ')


def migrate():
    """
    Apply changes to database
    """
    local('python manage.py migrate')


def superuser():
    """
    Create superuser
    """
    local('python manage.py createsuperuser')


def install_requir():
    """
    Install all required packages from requirements.txt
    """
    local(' pip install -r requirements.txt')

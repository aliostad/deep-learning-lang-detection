import os

from fabric.api import lcd, local, task


@task
def clear_pyc():
    """
    Recursively remove all local *.pyc files
    """
    local("find . -name '*.pyc' -delete")


@task
def manage(cmd):
    """
    Shortcut to run manage.py <cmd>. Appends --settings=tokeniz.settings.dev
    """
    with lcd(os.path.join(os.path.dirname(__file__), 'tokeniz')):
        local(
            'python manage.py {0} --settings=tokeniz.settings.dev'.format(cmd))


@task
def test(app=None):
    """
    Shortcut to run manage.py test [<app>].
        Appends --settings=tokeniz.settings.test
    """
    with lcd(os.path.join(os.path.dirname(__file__), 'tokeniz')):
        if app:
            local(
                'python manage.py test {0} --settings=tokeniz.settings.test'
                .format(app))
        else:
            local('python manage.py test --settings=tokeniz.settings.test')


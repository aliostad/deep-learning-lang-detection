from denim import django
from denim.constants import DeployUser, RootUser
from tests._utils import ApiTestCase


class TestDjango(ApiTestCase):
    def test_django_manage_simple_command(self):
        django.manage('test')

        self.assertSudo('python manage.py test --noinput',
            user=DeployUser.sudo_identity())

    def test_django_manage_command_with_args(self):
        django.manage('test', ['--arg1 234', '--arg2 foo'])

        self.assertSudo('python manage.py test --noinput --arg1 234 --arg2 foo',
            user=DeployUser.sudo_identity())

    def test_django_manage_command_with_input(self):
        django.manage('test', ['--arg1 234', '--arg2 foo'], noinput=False)

        self.assertSudo('python manage.py test --arg1 234 --arg2 foo',
            user=DeployUser.sudo_identity())

    def test_django_manage_dont_use_sudo(self):
        django.manage('test', use_sudo=False)

        self.assertRun('python manage.py test --noinput')

    def test_django_manage_use_sudo_with_user(self):
        django.manage('test', use_sudo=True, user='dave')

        self.assertSudo('python manage.py test --noinput', user='dave')

    def test_django_test_deploy(self):
        django.test_deploy()

        self.assertSudo('python manage.py validate',
            user=DeployUser.sudo_identity())

    def test_django_collectstatic(self):
        django.collectstatic()

        self.assertSudo('python manage.py collectstatic --noinput',
            user=RootUser.sudo_identity())

    def test_django_syncdb(self):
        django.syncdb()

        self.assertSudo('python manage.py syncdb --noinput',
            user=DeployUser.sudo_identity())

    def test_django_createsuperuser(self):
        django.createsuperuser()

from fabric.api import *


FILMFEST_MANAGE = 'PYTHONPATH=/var/lib/filmfest/config /var/lib/filmfest/bin/filmfest_manage '
FILMFEST_USER = 'filmfest'


def update():
    with settings(sudo_user=FILMFEST_USER):
        with cd('/var/lib/filmfest'):
            sudo('/var/lib/filmfest/bin/pip install '
                 'git+git://github.com/kinaklub/filmfest.by')
        sudo(FILMFEST_MANAGE + 'syncdb --noinput')
        sudo(FILMFEST_MANAGE + 'migrate --noinput')
        sudo(FILMFEST_MANAGE + 'collectstatic --noinput')
    sudo('systemctl restart filmfest')
    sudo('systemctl restart filmfest_celery')

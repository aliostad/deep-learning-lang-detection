from fabric.api import cd, local, run, env

env.use_ssh_config = True

def prepare_deploy():
    local("python pireader/manage.py test reader")
    local("git add -p && git commit")
    local("git push")

def deploy():
    with cd('/home/pi/pireader'):
        run('git pull')
        with cd('/home/pi/pireader/pireader'):
            run('python manage.py migrate reader')
            run('python manage.py test reader')
            run('python manage.py collectstatic')
            run('sudo /etc/init.d/fastcgi restart')
            run('sudo /etc/init.d/nginx reload')
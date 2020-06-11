from invoke import run, task

SSH_EXEC = "vagrant ssh -c '{}'"

@task
def css():
    print('# Compiling bootstrap')
    run(
        'sass bootstrap_djangit/djangit.scss\
         djangit/static/css/bootstrap-djangit.css'
    )


@task
def manage(cmd):
    """ Run arbitrary manage.py commands """
    manage_command = 'python /vagrant/djangit_project/manage.py {}'.format(cmd)
    run(SSH_EXEC.format(manage_command))


@task
def up(provision=False):
    cmd = 'vagrant up'
    if provision:
        cmd += ' --provision'
    print('# Running `{}`'.format(cmd))
    run(cmd)


@task
def serve():
    print('# Running development server')
    manage('runserver 0.0.0.0:8000')


@task
def start():
    up()
    css()
    serve()

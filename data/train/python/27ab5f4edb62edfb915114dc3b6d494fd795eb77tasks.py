from invoke import task

@task
def run(ctx):
    ctx.run('python manage.py runserver 8003')

@task
def resetmigrations(ctx):
    ctx.run('rm -rf aurora/migrations')
    ctx.run('rm -f db.sqlite3')
    ctx.run('mkdir aurora/migrations')
    ctx.run('touch aurora/migrations/__init__.py')
    ctx.run('python manage.py makemigrations')
    ctx.run('python manage.py migrate')

@task
def resetdb(ctx):
    ctx.run('rm -f db.sqlite3')
    ctx.run('python manage.py migrate')

@task
def ftest(ctx):
    ctx.run('bash functest.sh')

@task
def utest(ctx, verbose=False):
    ctx.run(f'python manage.py test {"-v2" if verbose else ""}')

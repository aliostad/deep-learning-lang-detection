from fabric.api import local

def zero(app="eclaim"):
	local("python manage.py migrate %s zero --settings=settings.development" % app )

def run():
	local("python manage.py runserver 0.0.0.0:80 --settings=settings.development")
	
def clear(app="eclaim"):
	local("rm -r %s/migrations" % app)

def shell():
	local("python manage.py shell --settings=settings.development")

def collectstatic():
	local("python manage.py collectstatic --noinput --settings=settings.production")

def gunicorn():
	local("gunicorn wsgi:application -b 0.0.0.0:3000 --settings=settings.production")

def clear_migrations():
	local("cd authentication")
	local("rm -rf migrations")

def syncdb():
	local("python manage.py syncdb --settings=settings.development")

def migrate_initial(app="apps.main"):
	local("python manage.py schemamigration %s --initial --settings=settings.development && python manage.py migrate %s --settings=settings.development" % (app,app))

def migration_update(app="apps.main"):
	local("python manage.py schemamigration %s --auto --update --settings=settings.development"% app)

def migration(app="apps.main"):
	local("python manage.py schemamigration %s --auto --settings=settings.development"% app)

def migrate(app="apps.main"):
	local("python manage.py migrate %s --settings=settings.development" % (app))

def createsuperuser():
	local("python manage.py createsuperuser --settings=settings.development")

def test(app="oai"):
    local("python manage.py test %s --settings=settings.development" % app)

def commit():
    local("git add -u && git commit -m 'ver readme' && git push origin master")

def prepare_deploy():
    test()
    commit()
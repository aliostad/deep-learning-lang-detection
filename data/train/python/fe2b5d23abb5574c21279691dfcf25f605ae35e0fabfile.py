from fabric.api import local

def manage_dev(command="runserver"):
    """
    e.g. manage_dev:"runserver 8004"
    """
    local("python manage.py %s "
      "--settings={{ project_name }}.settings.dev" % command)

def manage_prod(command="shell"):
    """
    e.g. manage_prod:syncdb
    """
    local("python manage.py %s "
      "--settings={{ project_name }}.settings.prod" % command)

def heroku_setup(heroku_app_name):
    """
    e.g. heroku_setup:my_heroku_app_name
    """
    #local("git flow init -d") # For git flow users
    local("git init")
    local("git add .")
    try:
        local("git commit -m 'First commit'")
    except:
        pass
    local("heroku apps:create %s" % heroku_app_name)

def heroku_push(commit_msg="trivial commit"):
    local("git add .")
    try:
        local("git commit -m '%s'" % commit_msg)
    except:
        pass
    local("git push heroku master")



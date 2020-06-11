from fabric.api import local

def test():
    local("./manage.py test")

def commit():
    local("git commit")

def push():
    local("git push origin master")

def up():
    test()
    push()

def coverage():
    local("coverage run manage.py test --settings=cherry.settings")
    local("coverage html --include=./* --omit='*migrations*'")

def migrate():
    local("rm -f db.sqlite3")
    local("rm -f core/migrations/*")
    local("rm -f documents/migrations/*")
    local("./manage.py makemigrations --empty core")
    local("./manage.py makemigrations --empty documents")
    local("./manage.py makemigrations")
    local("./manage.py migrate")
    local("./manage.py createsu")

def rst():
    local("rst-validate.py README.md")

def clean():
    local("find . -name '*.pyc' -exec rm {} +")
        
def status():
    clean()
    local("git status")

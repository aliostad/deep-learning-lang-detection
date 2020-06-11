from fabric.api import local

CMD_MANAGE = "python manage.py "

def build():
    local(CMD_MANAGE + 'makemigrations')
    local(CMD_MANAGE + 'migrate')

    test()

def celery():
    local("python manage.py celery -A rockit worker -l DEBUG -E -B -c 1")

def load_data(path):
    local(CMD_MANAGE + 'loaddata %s' % path)

def runserver(localonly=True):
    if localonly:
        local(CMD_MANAGE + 'runserver')
    else:
        local(CMD_MANAGE + 'runserver 0.0.0.0')

def setup(environment):
    local('pip install -r requirements/%s' % environment)

def test():
    local(CMD_MANAGE + 'test')
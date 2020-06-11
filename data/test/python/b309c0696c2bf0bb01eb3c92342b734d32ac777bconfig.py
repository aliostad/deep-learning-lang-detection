import os


# get db uri from env variables, if not found assume there is a mongo instance locally.

DB_URI = os.getenv('MONGO_URI','localhost')

DB_USER =os.getenv('DB_USER',None)
DB_PWD =os.getenv('DB_PWD',None)

ENV_NAME =  os.getenv('ENV_NAME', None)

CSRF_ENABLED = True
SECRET_KEY = 'titi'

# get rabbitmq base & username/pass from env variables, if not found assume local/guest
BROKER_BASE = os.getenv('BROKER_BASE','localhost')
RABBITMQ_USER = os.getenv('RABBITMQ_USER', 'guest')
RABBITMQ_PASS = os.getenv('RABBITMQ_PASS', 'guest')

BROKER_URL = 'amqp://'+RABBITMQ_USER+':'+RABBITMQ_PASS+'@'+BROKER_BASE+':5672//'

DOC_EMAIL = os.getenv('DOC_EMAIL', None)
DOC_LINK = os.getenv('DOC_LINK', None)

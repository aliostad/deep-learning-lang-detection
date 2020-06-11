import os

#BROKER_URL = 'sqla+sqlite:///celerydb.sqlite'
BROKER_URL = 'amqp://ravenel:sailor@localhost:5672/myvhost'

#BROKER_HOST = 'localhost'
#BROKER_PORT = 5672
#BROKER_USER = 'ravenel'
#BROKER_PASSWORD = 'sailor'
#BROKER_VHOST = 'myvhost'

CELERY_IMPORTS = ('tasks',)
#CELERY_LOG_FILE = os.path.join(os.path.abspath(__file__), 'log.txt')
#CELERYD_LOG_FILE = os.path.join(os.path.split(os.path.abspath(__file__))[0], 'log.txt')

#Location to write the output csv file--used by Celery task
csv_output = os.path.join(os.path.split(os.path.abspath(__file__))[0], 'output.csv')

from datetime import timedelta
# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '_3jqru(q6ph1$fim39jlycghw75uz86&s82#d3%yilip8pdzgg'

#BROKER SETTINGS
#BROKER_POOL_LIMIT = 0
#BROKER_URL = 'amqp://lojcolbi:Xnt8vZ4-93gfxH0jwGwu1pos2SNhtdpf@lemur.cloudamqp.com/lojcolbi' 
BROKER_URL = 'amqp://admin:redmetal@54.187.186.26:5672/'
CELERY_RESULT_BACKEND = ''

EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = 'dtsmsreminder@gmail.com'
EMAIL_HOST_PASSWORD = 'redmetal'

#CELERYBEAT_SCHEDULE = {
#    'check-every-30-seconds': {
#        'task': 'SMSApp.tasks.getQueueMessage',
#        'schedule': timedelta(seconds=30)
#    },
#}
"""myapp.py

Usage:

   (window1)$ python myapp.py -l info

   (window2)$ python
   >>> from myapp import add
   >>> add.delay(16, 16).get()
   32


You can also specify the app to use with celeryd::

    $ celeryd -l info --app=myapp.celery

"""

import sys
sys.path.insert(0,'lib')
sys.path.insert(0, 'lib/celery')
sys.path.insert(0, 'lib/kombu')


from celery import Celery
BROKER_BACKEND = 'redis'
BROKER_HOST = '127.0.0.1'
BROKER_PORT = 6379
BROKER_VHOST = '12'

CELERY_RESULT_BACKEND = "redis"
REDIS_HOST = '127.0.0.1'
REDIS_PORT = 6379
REDIS_DB = '100'
REDIS_CONNECT_RETRY = True


celery = Celery("myapp")
#celery.conf.update(BROKER_URL="amqp://guest:guest@localhost:5672//")
celery.conf.update(BROKER_BACKEND='redis')
celery.conf.update(BROKER_HOST='127.0.0.1')
celery.conf.update(BROKER_PORT=6379)
celery.conf.update(BROKER_VHOST='12')

print celery.conf

@celery.task
def add(x, y):
    print 'i am doing work'
    return x + y

if __name__ == "__main__":
    import celery.bin.celeryd
    celery.bin.celeryd.main()

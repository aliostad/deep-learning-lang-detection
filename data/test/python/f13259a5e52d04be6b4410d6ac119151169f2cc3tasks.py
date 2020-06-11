#usage:
#under current directory: celery -A tasks worker --loglevel=info
#python run_tasks.py
#you could use flower to monitor Celery:
#celery flower --broker=redis://guest:guest@localhost:6379/0

from __future__ import absolute_import

from celery import Celery
#from stocktrace import settings

#broker = 'redis://192.168.192.128:6379/0'
BROKER_URL = 'mongodb://localhost:27017/stock'
app = Celery('tasks', backend=BROKER_URL, broker=BROKER_URL)


@app.task()
def add(x, y):
    return x + y

if __name__ == '__main__':
    app.start()

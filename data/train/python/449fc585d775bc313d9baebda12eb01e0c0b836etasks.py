import eddy
from celery import Celery

BROKER_URL = 'amqp://guest:guest@localhost:5672//'

celery = Celery('perf', backend='amqp', broker=BROKER_URL)

@celery.task
def perftest(appname):
    name, slug = eddy.loadApp(appname)
    results = eddy.testApp(name, slug)
    return results

def get_one_message(app, queue_name, no_ack=False, connection=None):
    with app.connection_or_acquire(connection) as conn:
        queue = app.amqp.queues[queue_name](conn)
        return queue.get(no_ack=no_ack)

def consume_one():
    app = Celery(broker=BROKER_URL)
    msg = get_one_message(app, 'celery')
    if msg:
        msg.ack()
        return msg.payload
    else:
        return None

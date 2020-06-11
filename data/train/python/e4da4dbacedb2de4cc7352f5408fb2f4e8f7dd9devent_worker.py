import yagi.config
import yagi.log
import yagi.utils

LOG = yagi.log.logger

with yagi.config.defaults_for('event_worker') as default:
    default('pidfile', 'yagi_event_worker.pid')
    default('daemonize', 'False')
    default('event_driver', 'yagi.broker.rabbit.Broker')


def start(consumers):
    broker = yagi.utils.import_class(yagi.config.get('event_worker',
                                                     'event_driver'))()
    for consumer in consumers:
        broker.add_consumer(consumer)
    broker.loop()

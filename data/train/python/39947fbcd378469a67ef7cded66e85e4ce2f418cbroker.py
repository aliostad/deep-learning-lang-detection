from django.conf import settings
import redis


class RedisBroker(object):
    instance = None

    def __init__(self):
        if not self.instance:
            self.connection = redis.Redis(
                    settings.REDIS_URL, settings.REDIS_PORT)
            self.instance = self
        else:
            self = self.instance

    def notify(self, channel, message):
        print "sending message '{message}' on channel '{channel}' PORT-{port}, HOST-{host}".format(
                            message=message,
                            channel=channel,
                            port=settings.REDIS_PORT,
                            host=settings.REDIS_URL
                        )
        return self.connection.publish(channel, message)


class DefaultBroker(object):
    def __init__(self):
        print "INVALID BROKER NAME - RUNING IN DEFAULT MODE \
                (PRINTING MESSAGES IN CONSOLE)"

    def notify(self, channel, message):
        print "sending message '{message}' on channel '{channel}' \
                PORT-{port}, HOST-{host}".format(
                            message=message,
                            channel=channel,
                            port=settings.REDIS_PORT,
                            host=settings.REDIS_URL
                        )

broker_map = {
        'redis': RedisBroker,
    }

broker = broker_map.get(settings.KICKER_BROKER, DefaultBroker)()
send_message = broker.notify

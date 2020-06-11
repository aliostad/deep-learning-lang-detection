import cyclone.web

from cyclone_sse.handlers import BroadcastHandler
from cyclone_sse.handlers import PublishHandler
from cyclone_sse.handlers import StatsHandler

from cyclone_sse.brokers import HttpBroker
from cyclone_sse.brokers import RedisBroker
from cyclone_sse.brokers import AmqpBroker

from cyclone_sse.periodic import GraphiteExport


class CustomBroadcastHandler(BroadcastHandler):

    #def authorize(self):
    #    #raise cyclone.web.HTTPAuthenticationRequired
    #    pass

    def get_channels(self):
        return ["base", "node"]


class App(cyclone.web.Application):
    def __init__(self, settings):
        handlers = [
            (r"/", CustomBroadcastHandler),
            (r"/stats", StatsHandler),
        ]

        if settings["broker"] == 'amqp':
            broker = AmqpBroker
        elif settings["broker"] == 'redis':
            broker = RedisBroker
        else:
            broker = HttpBroker
            handlers.append((r"/publish", PublishHandler))

        self.broker = broker(settings)

        if settings['export'] and settings['export'] == 'graphite':
            graphite = GraphiteExport(self.broker, settings)

        cyclone.web.Application.__init__(self, handlers)

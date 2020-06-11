__ALL__ = ['publish', 'subscribe']

class _EventBroker(object):
    def __init__(self):
        self._listeners = {}

    def subscribe(self, topic, listener):
        if topic not in self._listeners:
            self._listeners[topic] = []

        self._listeners[topic].append(listener)

    def publish(self, topic, **kwargs):
        if topic not in self._listeners:
            return
        else:
            for listener in self._listeners[topic]:
                listener(**kwargs)

_broker = _EventBroker()

def publish(topic, **kwargs):
    _broker.publish(topic, **kwargs)

def subscribe(topic, listener):
    _broker.subscribe(topic, listener)

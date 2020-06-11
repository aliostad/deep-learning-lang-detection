from kivy.logger import Logger

class DummyEventBroker(object):
    """
    A dummy event broker that just prints the events it receives.
    """
    class DummyPrinter:
        def __init__(self, event):
            self._event_name=event

        def __call__(self, *argv, **kwargs):
            Logger.info('DummyEventBroker: event fired');
	    print "Event: %s fired with %s %s" % (self._event_name, argv, kwargs)

    def __getattr__(self, attr):
        return self.DummyPrinter(attr)

def getDummyEventBroker(obj):
    return DummyEventBroker()


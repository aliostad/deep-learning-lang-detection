
class Broker(object):
    
    def __init__(self, broker):
        self.broker = broker
        
    def establish_connection(self):
        '''Establish a connection with Broker Server'''
        raise NotImplementedError('Need implementation')
    

class Exchange(object):
    '''This is the message broker, responsable for creating
a market for messages between producers and consumers.
'''
    _closed = None
    _connection = None
    
    def __init__(self, broker_cls):
        self.broker = broker_cls(self)
    
    @property
    def connection(self):
        if self._closed:
            return
        if not self._connection:
            self._connection = self.broker.establish_connection()
            self._closed = False
        return self._connection
    
    def channel(self):
        """Request a new channel."""
        return self.broker.create_channel(self.connection)
    
    def close(self):
        if self._connection:
            try:
                self.broker.close_connection(self._connection)
            except self.broker.connection_errors:
                pass
            self._connection = None
        self._closed = True
    
    
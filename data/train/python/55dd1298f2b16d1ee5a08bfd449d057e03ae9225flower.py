"""
StackMan
Colton J. Provias - cj@coltonprovias.com
"""

from stackman.stack import StackItem


class Flower(StackItem):
    """
    Let a flower blossom on top of Celery.

    Arguments:
    * base_command str Command
                  Default: flower
    * port int Port to bind to
               Default: 5555
    * broker str Broker
                 Default: amqp://guest@localhost:5672//
    """
    ready_text = 'Connected to'

    @property
    def command(self):
        fmap = {'base': self.base_command,
                'port': self.port,
                'broker': self.broker}
        return '{base} --port={port} --broker_api={broker} --broker={broker}'.format_map(fmap)

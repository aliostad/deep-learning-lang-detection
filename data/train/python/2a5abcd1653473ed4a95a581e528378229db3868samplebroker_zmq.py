__author__ = 'achmed'

import config

from griffinmcelroy.services.broker import ZMQSampleBroker
from griffinmcelroy.args import get_opts


import logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger('samplebroker_zmq')
logger.setLevel(logging.DEBUG)

def main():
    opts = get_opts()

    c = config.Config(opts.config)
    if not hasattr(c, 'broker'):
        raise Exception('config is missing broker section')

    b = ZMQSampleBroker(c.broker)
    b.initialize()
    b.start()


if __name__ == '__main__':
    main()

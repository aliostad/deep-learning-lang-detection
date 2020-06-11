from __future__ import with_statement

from django.conf import settings
from kombu.compat import Publisher
from kombu.connection import BrokerConnection

CONFIG = settings.MESSAGE_BROKER_CONFIGS[settings.MESSAGE_BROKER_ACTIVE_CONFIG]

def get_connection():
    """Return a new connection to the currently defined message broker.
    """
    kwargs = CONFIG['connection']
    return BrokerConnection(**kwargs)

def customer_created(customer):
    """
    Push details for the supplied customer to the `accounts` exchange.
    
    The Content-Type of the message is set to "application/json" and the body is
    set to the JSON-encoded customer, E.g.::
    
        {'account': u'05dd077bcf324f8fa975bb132e7b04cc',
        'address': u'',
        'msisdn': u'2348035082026',
        'name': u'Madueke Stanislaus Chukwueloka',
        'services': [u'BUZZ', u'911']}
    """
    with get_connection() as conn:
        with Publisher(conn, **CONFIG['exchanges']['accounts']) as publisher:
            publisher.send(customer)

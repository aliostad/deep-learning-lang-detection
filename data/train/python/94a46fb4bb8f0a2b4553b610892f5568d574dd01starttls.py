from irclib.common.dispatch import PRIORITY_DEFAULT
from irclib.common.numerics import *

""" Dispatch STARTTLS """
def dispatch_starttls(client, line):
    # Wrap the socket
    client.wrap_ssl()

    # Now safe to do this
    client.dispatch_register()


def dispatch_starttls_fail(client, line):
    # Failed somehow.
    client.use_ssl = False
    client.logger.critical('SSL is non-functional on this connection!')


hooks_in = (
    (RPL_STARTTLS, PRIORITY_DEFAULT, dispatch_starttls),
    (ERR_STARTTLS, PRIORITY_DEFAULT, dispatch_starttls_fail),
)


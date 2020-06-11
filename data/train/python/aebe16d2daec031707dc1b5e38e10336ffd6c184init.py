"""aque init - Initialize a broker's datastore.

Runs any required schema migrations to bring the broker's datastore up to date
with the latest version of AQue.

This is idempotent in its basic form (i.e. `aque init`)."""

import sys

from aque.commands.main import command, argument
from aque.worker import Worker


@command(
    argument('--reset', action='store_true', help='reset the datastore completely'),
    help="initialize a broker's datastore",
    description=__doc__,
)
def init(args):
    if args.reset:
        args.broker.destroy_schema()
    args.broker.update_schema()

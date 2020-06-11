#!/usr/bin/env python

import sys
import os

def get_broker():
    if 'BROKER' in os.environ:
        return os.environ['BROKER']
    addr = 'RABBITMQ_PORT_5672_TCP_ADDR' # 172.17.0.2
    port = 'RABBITMQ_PORT_5672_TCP_PORT' # 5672
    vars_needed = (addr, port)
    for var in vars_needed:
        if var not in os.environ:
            break
    else:
        # we have all the environment variables
        return 'amqp://{}:{}/'.format(os.environ[addr], os.environ[port])


def execute(args):
    return os.execvp('reviewbot', ['reviewbot'] + args)


def main(args=sys.argv[1:]):
    for arg in args:
        if arg in ('-b', '--broker'):
            return execute(args)
        if arg.startswith('--broker='):
            return execute(args)
    new_args = args[:]
    broker = get_broker()
    if broker:
        new_args.append('--broker={}'.format(broker))
    return execute(new_args)

if __name__ == '__main__':
    main()


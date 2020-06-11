import signal

import click
import stomp

from minecart.packager import ApiListener


@click.group()
def main():
    pass


@main.command()
@click.option('--broker-host', default='localhost')
@click.option('--broker-port', default=61613)
@click.option('--api-host', default='localhost')
@click.option('--api-port', default=80)
@click.option('--repo-host', default='locahost')
@click.option('--repo-port', default=8080)
@click.option('--queue', default='/queue/api')
def run(broker_host, broker_port, api_host, api_port, repo_host, repo_port,
        queue):
    conn = stomp.Connection([(broker_host, broker_port)])
    conn.set_listener('archiver', ApiListener())
    conn.start()
    conn.connect(wait=True)
    conn.subscribe(queue, 1)

    while True:
        signal.pause()

# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.core.management.base import BaseCommand, CommandError

import threading
from optparse import make_option
from distributed_task.broker import get_broker
from distributed_task.core.handler import task_handler
from distributed_task.exceptions import BrokerConnectionError


class Command(BaseCommand):

    option_list = BaseCommand.option_list + (
        make_option("-c", "--cron", dest="exec_cron",
                    help="Execution stops if all tasks are worked off.", action="store_true"),
        make_option("-d", "--daemon", dest="exec_daemon",
                    help="Daemon mode.", action="store_true"),
        make_option("-w", "--worker", dest="worker",
                    help="Number of processes to start.", default=1, type="int"),
    )

    help = "Starts the worker process."

    def handle(self, *args, **options):

        if options.get('exec_cron'):
            self.run_as_script(**options)
        else:
            self.run_as_daemon(**options)

    def get_broker(self):
        try:
            broker = get_broker()
            return broker

        except BrokerConnectionError, e:
            self.stderr.write("Connection to broker failed: %s" % e)
        except KeyboardInterrupt:
            self.stdout.write("Stopped.")

    def run_as_daemon(self, **options):
        worker_count = options.get("worker")

        def worker_process():
            broker = get_broker()
            broker.keep_consuming(task_handler)

        for i in range(worker_count):
            t = threading.Thread(target=worker_process)
            t.daemon = True
            t.start()

    def run_as_script(self, **options):

        broker = get_broker()
        broker.consume_message(task_handler)
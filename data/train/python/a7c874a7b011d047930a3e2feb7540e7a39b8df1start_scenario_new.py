#!/usr/bin/python
# (c) Nelen & Schuurmans.  GPL licensed.

from optparse import make_option

from django.core.management.base import BaseCommand
from flooding_worker.file_logging import setFileHandler, removeFileHandlers
from flooding_worker.worker.action_workflow import ActionWorkflow
from flooding_worker.worker.broker_connection import BrokerConnection
from flooding_worker.worker.message_logging_handler import AMQPMessageHandler

import logging
log = logging.getLogger("flooding.management.start_scenario")


class Command(BaseCommand):

    help = ("Example: bin/django start_scenario_new "\
            "--scenario_id 50 "\
            "--workflowtemplate_id 1 "\
            "--log_level DEBUG")

    option_list = BaseCommand.option_list + (
            make_option('--log_level',
                        help='logging level 10=debug 50=critical',
                        default='DEBUG',
                        type='str'),
            make_option('--scenario_id',
                        help='scenarios',
                        type='int'),
            make_option('--workflowtemplate_id',
                        help='id of workflow template',
                        type='int'))

    def handle(self, *args, **options):
        """
        Opens connection to broker.
        Creates ActionWorkflow object.
        Creates logging handler to send loggings to broker.
        Sets logging handler to ActionWorkflow object.
        Performs workflow.
        Closes connection.
        """
        numeric_level = getattr(logging, options["log_level"].upper(), None)
        if not isinstance(numeric_level, int):
            log.error("Invalid log level: %s" % options["log_level"])
            numeric_level = 10

        broker = BrokerConnection()
        connection = broker.connect_to_broker()

        removeFileHandlers()
        setFileHandler('start')

        if connection is None:
            log.error("Could not connect to broker.")
            return

        action = ActionWorkflow(
            connection, options["scenario_id"], options["workflowtemplate_id"])

        logging.handlers.AMQPMessageHandler = AMQPMessageHandler
        broker_handler = logging.handlers.AMQPMessageHandler(action,
                                                             numeric_level)

        action.set_broker_logging_handler(broker_handler)
        action.perform_workflow()

        if connection.is_open:
            connection.close()

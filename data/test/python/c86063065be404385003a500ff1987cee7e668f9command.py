from flow.commands.service import ServiceCommand
from flow.configuration.inject.broker import BrokerConfiguration
from flow_workflow.configuration.inject.oltp import OLTPConfiguration
from flow_workflow.historian import handler

import logging


LOG = logging.getLogger(__name__)


class WorkflowHistorianCommand(ServiceCommand):
    injector_modules = [
            BrokerConfiguration,
            OLTPConfiguration,
    ]

    def _setup(self, *args, **kwargs):
        self.handlers = [
            self.injector.get(handler.HistorianUpdateHandler),
        ]

        return ServiceCommand._setup(self, *args, **kwargs)

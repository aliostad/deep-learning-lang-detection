from flow.configuration.inject.local_broker import BrokerConfiguration
from flow.configuration.inject.redis_conf import RedisConfiguration
from flow.configuration.inject.service_locator import ServiceLocatorConfiguration
from flow.orchestrator.handlers import PetriCreateTokenHandler
from flow.orchestrator.handlers import PetriNotifyPlaceHandler
from flow.orchestrator.handlers import PetriNotifyTransitionHandler
from flow.shell_command.fork.handler import ForkShellCommandMessageHandler
from flow_workflow.commands.launch_base import LaunchWorkflowCommandBase
from flow_workflow.historian import handler
from twisted.internet import defer


class ExecuteWorkflowCommand(LaunchWorkflowCommandBase):
    injector_modules = [
            BrokerConfiguration,
            RedisConfiguration,
            ServiceLocatorConfiguration,
    ]

    local_workflow = True

    def setup_services(self, net):
        self.setup_shell_command_handlers()
        self.setup_orchestrator_handlers()
        self.setup_historian_handler()

        self.setup_completion_handler(net)

    def setup_shell_command_handlers(self):
        self.broker.register_handler(
                self.injector.get(ForkShellCommandMessageHandler))

    def setup_orchestrator_handlers(self):
        self.broker.register_handler(
                self.injector.get(PetriCreateTokenHandler))
        self.broker.register_handler(
                self.injector.get(PetriNotifyPlaceHandler))
        self.broker.register_handler(
                self.injector.get(PetriNotifyTransitionHandler))

    def setup_historian_handler(self):
        self.broker.register_handler(
                self.injector.get(handler.HistorianUpdateHandler))

    def wait_for_results(self, net, block):
        wait_deferred = defer.Deferred()
        listen_deferred = self.broker.listen()
        listen_deferred.addCallback(lambda x:wait_deferred.callback(block))
        listen_deferred.addErrback(wait_deferred.errback)
        return wait_deferred

from common_processes import *
from messages import *
from registry import *

class BrokerListenProcess(SignalProcess):
    def __init__(self, broker):
        super(BrokerListenProcess, self).__init__(self.__class__.__name__)
        self.broker = broker

    def listen(self):
        while 1:
            yield passivate, self

            if self.have_signal("allocate"):
                self.broker.allocate(self.get_signal_value("allocate"))
            elif self.have_signal("update"):
                self.broker.update(self.get_signal_value("update"))
            elif self.have_signal("sync"):
                self.broker.sync(self.get_signal_value("sync"))
            else:
                self.broker.trace("WARNING: broker woken up unexpetedly")

class BrokerUpdateProcess(SignalProcess):
    def __init__(self, broker):
        super(BrokerUpdateProcess, self).__init__(self.__class__.__name__)
        self.broker = broker

    def update(self):
        # 1st time, to avoid syncing with others, wait random time
        time = random.random() * self.broker.sync_time
        yield hold, self, time
        
        while 1:
            self.broker.send_sync()
            yield hold, self, self.broker.sync_time


class ResourceUpdateProcess(SignalProcess):
    def __init__(self, agent):
        super(ResourceUpdateProcess, self).__init__(self.__class__.__name__)
        self.agent = agent

    def update(self):
        # 1st time, to avoid syncing with others, wait random time
        time = random.random() * self.agent.update_time
        yield hold, self, time

        while 1:
            state = ResourceState(self.agent, self.agent.resource.free)
            msg = Update(state)
            msg.send_msg(self.agent.node, self.agent.broker.node)
            yield hold, self, self.agent.update_time


class ResourceListenProcess(SignalProcess):
    def __init__(self, agent):
        super(ResourceListenProcess, self).__init__(self.__class__.__name__)
        self.agent = agent

    def listen(self):
        while 1:
            yield passivate, self

            if self.have_signal("accept"):
                self.agent.accept_received(self.get_signal_value("accept"))
            elif self.agent.trace:
                self.agent.trace("WARNING: ragent got unknown signal")
                


class AllocateProcess(SignalProcess):
    def __init__(self, agent):
        super(AllocateProcess, self).__init__(self.__class__.__name__)
        self.agent = agent

    def allocate(self):
        yield hold, self, self.agent.allocate_timeout

        if self.have_signal("response"):
            self.agent.response(self.get_signal_value("response"))
        else:
            self.agent.allocate_timedout()




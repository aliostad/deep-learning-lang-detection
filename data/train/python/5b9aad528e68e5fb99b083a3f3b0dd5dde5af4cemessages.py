from message import Message
from common_messages import *
from record import mdsrecord as record

class Allocation(object):
    def __init__(self, jagent, ragent=None):
        self.jagent = jagent
        self.ragent = ragent

    @property
    def job(self):
        return self.jagent.job

    @property
    def id(self):
        return self.jagent.job.id

    def __str__(self):
        return "Alloc(%s, %s)" % (self.jagent, self.ragent)


class MessageWithAllocation(Message):
    def __init__(self, allocation, *a, **kw):
        super(MessageWithAllocation, self).__init__(*a, **kw)
        self.allocation = allocation

class AllocationRequest(MessageWithAllocation):
    def process(self, src, dst, trace, **kw):
        if dst.broker:
            dst.broker.listen_process.signal("allocate", self.allocation)
        else:
            trace("WARNING: no broker for allocate request at node %s" %
                    (dst.id))

class AllocationResponse(MessageWithAllocation):
    def process(self, src, dst, trace, **kw):
        agent = check_target(dst, self.allocation.jagent, trace)
        if agent:
            agent.allocate_process.signal("response", self.allocation)

class Update(Message):
    def __init__(self, state, **kw):
        super(Update, self).__init__()
        self.state = state

    def process(self, src, dst, trace, **kw):
        if dst.broker:
            dst.broker.listen_process.signal("update", self.state)
        else:
            trace("WARNING: no broker for allocate request at %s" % dst)


class SyncMessage(Message):
    def __init__(self, states, **kw):
        super(SyncMessage, self).__init__()
        self.states = states

    def process(self, src, dst, trace, **kw):
        if dst.broker:
            dst.broker.listen_process.signal("sync", self.states)
        else:
            trace("WARNING: no broker for sync request at %s" % dst)



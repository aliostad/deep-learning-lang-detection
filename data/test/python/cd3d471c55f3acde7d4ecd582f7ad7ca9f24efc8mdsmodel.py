import random
from SimPy.Simulation import Monitor
from models import GridModel
import network
import record
import stats
from stats import dists
from broker import Broker
from mdsagents import *
from registry import *
from messages import *
from record import mdsrecord as record

class MdsModel(GridModel):

    def __init__(self, 
            registry_type=Registry,
            broker_means=dists.normal(0.05),
            **kw):
        super(MdsModel, self).__init__(**kw)

        regions = self.graph.regions
        self.regions = [i for i in range(regions[0]*regions[1])]

        self.brokers = dict()
        for r in self.regions:
            node = self.random_region_node(r)
            node.server.service_time = self.service_dist(broker_means())
            broker = Broker(
                    r, 
                    node, 
                    registry_type(),
                    60,
                    self.brokers)
            
            # give them an intitial picture of the grid
            for node in self.graph.nodes_in_region(r):
                state = ResourceState(node.resource_agent, node.resource.free)
                broker.registry.update_state(state)

            self.brokers[r] = broker

        for node in self.graph.nodes_iter():
            node.broker = self.brokers[node.region]
            # this nodes resource agent
            node.resource_agent = MdsResourceAgent(node, 30) 
            # mapping of jobagents at this node

            # make a link to fast comms to the broker
            self.graph.make_link(node, node.broker.node)

        # ensure brokers have fast links to each other
        for i, broker in enumerate(self.brokers.itervalues()):
            for other in self.brokers.values()[i:]:
                self.graph.make_link(broker.node, other.node)

        self.mons["broker_util"] = Monitor("broker_util")
        self.mons["broker_queue"] = Monitor("broker_queue")

    def new_process(self):
        node = self.random_node()
        job = self.new_job()
        agent = MdsJobAgent(job, 20, 20, 5)
        agent.start_on(node)

    def start(self, *a, **kw):
        for n in self.graph.nodes_iter():
            n.resource_agent.start()
        for b in self.brokers.itervalues():
            b.start()
        super(MdsModel, self).start(*a, **kw)

    def calc_results(self):
        return record.calc_results(self)
        
    def collect_stats(self):
        super(MdsModel, self).collect_stats()
        self.mons["broker_util"].observe(stats.mean_broker_server_util(self))
        self.mons["broker_queue"].observe(stats.mean_broker_queue_time(self))

        



from helpers.waiter import Waiter
from factories.param_factory import ParamFactory

class Repository:
    def __init__(self,api):
        self.api = api

class DatacenterRepository(Repository):
    def __init__(self,api):
        Repository.__init__(self,api)

    def create(self,params=ParamFactory().create_datacenter()):
        if('datcenters' in dir(self.api)):
            return self.api.datacenters.add(params)

    def show(self, datacenter):
        if('datcenters' in dir(self.api)):
            return self.api.datacenters.get(datacenter.get_name())

    def destroy(self, datacenter):
        if('datcenters' in dir(self.api)):
            datacenter_broker = self.show(datacenter)
            datacenter_broker.delete()

class ClusterRepository(Repository):
    def __init__(self,api):
        Repository.__init__(self,api)

    def show(self, cluster):
        return self.api.clusters.get(cluster.get_name())

    def create(self,params=ParamFactory().create_cluster()):
        return self.api.clusters.add(params)

    def destroy(self,cluster):
        cluster_broker = self.show(cluster)
        return cluster_broker.delete()
class HostRepository(Repository):
    def __init__(self,api):
        Repository.__init__(self,api)

    def create(self,params):
        return self.api.hosts.add(params)

    def show(self,host):
        return self.api.hosts.get(id=host.id)

    def refresh(self, host):
        return self.show(self.api,host)

    def destroy(self, host):
        host_broker = self.show(host)
        host_broker.delete()

    def deactivate(self,host):
        host_broker = self.show(host)
        host_broker.deactivate()

class VolumeRepository(Repository):
    def __init__(self,api):
        Repository.__init__(self,api)

    def create(self,cluster,params):
        cluster_broker = ClusterRepository(self.api).show(cluster)
        return cluster_broker.glustervolumes.add(params)




__author__ = 'zhangbohan'
from pkg.infrastructure.integration.kubernetes.model.replicationController.ReplicationController import ReplicationController


class ReplicationControllerManage(object):
    def __init__(self, kubenetesClient=None):
        self.kubenetesClient = kubenetesClient
        pass

    def createReplicationController(self,replicationControllerRequest):
        self.kubenetesClient.createReplicationController(replicationControllerRequest)
        pass

    def deleteReplicationController(self, replicationControllerRequest):
        ReplicationControllerId = replicationControllerRequest.getId()
        result = self.kubenetesClient.deleteReplicationController(ReplicationControllerId)
        return result

    def queryReplicationController(self, replicationControllerRequest):
        ReplicationControllerId = replicationControllerRequest.getId()
        result = self.kubenetesClient.queryReplicationController(ReplicationControllerId)
        return result

    def queryReplicationControllersInFarm(self, replicationControllerRequest):
        labels = replicationControllerRequest.getLabels()
        labelName = "farmlabel"
        labelValues = labels[labelName]
        queryLabels = "%s=%s" % (labelName, labelValues)
        result = self.kubenetesClient.queryReplicationControllerByLabel(queryLabels)
        return result

    def queryReplicationControllersInRole(self, replicationControllerRequest):
        labels = replicationControllerRequest.getLabels()
        labelName = "rolelabel"
        labelValues = labels[labelName]
        queryLabels = "%s=%s" % (labelName, labelValues)
        result = self.kubenetesClient.queryReplicationControllerByLabel(queryLabels)
        return result

    def resizeReplicationController(self, replicationControllerRequest, newSize):
        ReplicationControllerId = replicationControllerRequest.getId()
        status, result = self.kubenetesClient.queryReplicationController(ReplicationControllerId)
        if status == 200:
            recentReplicationControllerModel = ReplicationController.fromJSON(result)
            resourceVersion = recentReplicationControllerModel.getResourceVersion()
            replicationControllerRequest.setResourceVersion(resourceVersion)
            self.kubenetesClient.updateReplicationController(ReplicationControllerId)

class ControllerRPCHandler:
    def __init__(self, controllerInstance):
        self.controllerInstance = controllerInstance
    def prejoin(self, requester):
        return self.controllerInstance.prejoin(requester)
    def join(self, requester, nodes, distances, topic):
        return self.controllerInstance.join(requester, nodes, distances, topic)
    def leave(self, requester, topic):
        return self.controllerInstance.leave(requester, topic)
    def complain(self, requester, offender):
        return self.controllerInstance.complain(requester, offender)
    def root(self, topic):
        return self.controllerInstance.treeRoot(topic)
    def ping(self):
        return True

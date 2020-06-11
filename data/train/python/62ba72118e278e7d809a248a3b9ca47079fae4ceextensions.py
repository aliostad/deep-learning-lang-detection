

class ExtensionResource(object):
    def __init__(self, name, resource, controller):
        self._name = name
        self._resource = resource
        self._controller = controller

    @property
    def name(self):
        return self._name

    @property
    def resource(self):
        return self._resource

    @property
    def controller(self):
        return self._controller


class BaseExtension(object):
    def __init__(self):
        pass

    def get_resource(self):
        return ExtensionResource(
                        self.name, 
                        self.resource,
                        self.controller
                        )

from dispatch_types import *
from dispatch_hue import *

class Dispatch:

    def __init__(self, dispatch_type=dispatch_type_hue):
        self.dispatch_type = dispatch_type

    def get(self, resource, debug=False):
        if self.dispatch_type == dispatch_type_hue:
            return DispatchHue().get(resource, debug)
        else:
            raise("Dispatch type not supported")

    def update(self, resource, debug=False):
        if self.dispatch_type == dispatch_type_hue:
            return DispatchHue().update(resource, debug)
        else:
            raise("Dispatch type not supported")

    def alert(self, which):
        if self.dispatch_type == dispatch_type_hue:
            return DispatchHue().alert(which)
        else:
            raise("Dispatch type not supported")
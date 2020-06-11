from ControlledSystem import *

class ZeroController(Controller):
    def __init__(self):
        pass
    def control_input(self, x):
        return 0
        
class ConstantController(Controller):
    def __init__(self, c):
        self.c = c
    def control_input(self, x):
        return self.c

class TVController(Controller):
    def __init__(self, f):
        self.f = f
    def control_input_tv(self, x, t):
        return self.f(t)
        
class LinearController(Controller):
    def __init__(self, K):
        self.K = K
    def control_input(self, x):
        return self.K * x

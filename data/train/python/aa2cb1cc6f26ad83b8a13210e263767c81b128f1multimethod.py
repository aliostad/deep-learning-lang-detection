class DispatchError(Exception): pass

class DefaultImplementation(object):
    def __repr__(self):
        return "<Default>"

default = DefaultImplementation()

class defmulti(object):
    def __init__(self, dispatch_fn):
        self.dispatch_fn = dispatch_fn
        self.implementations = {}

    def __call__(self, *args, **kwargs):
        dispatch = self.dispatch_fn(*args, **kwargs)
        if dispatch in self.implementations:
            return self.implementations[dispatch](*args, **kwargs)
        elif default in self.implementations:
            return self.implementations[default](*args, **kwargs)
        else:
            raise DispatchError("no implementation found for dispatch value: "
                                + str(dispatch))

    def dispatch_on(self, dispatch):
        def register_method(fn):
            self.implementations[dispatch] = fn
            return fn
        return register_method

__all__ = ['defmulti', 'default']

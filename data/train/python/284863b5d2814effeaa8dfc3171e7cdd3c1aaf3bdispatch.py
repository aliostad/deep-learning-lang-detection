# -*- coding: utf-8 -*-


def dispatch(*funcs):
    '''Iterates through the functions
    and calls them with given the parameters
    and returns the first non-empty result

    >>> f = dispatch(lambda: None, lambda: 1)
    >>> f()
    1

    :param \*funcs: funcs list of dispatched functions
    :returns: dispatch functoin
    '''

    def _dispatch(*args, **kwargs):
        for f in funcs:
            result = f(*args, **kwargs)
            if result is not None:
                return result
        return None

    return _dispatch

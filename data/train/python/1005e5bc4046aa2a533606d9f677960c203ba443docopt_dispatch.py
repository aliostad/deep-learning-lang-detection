"""Dispatch from command-line arguments to functions."""
import re
from collections import OrderedDict


__all__ = ('dispatch', 'DispatchError')
__author__ = 'Vladimir Keleshev <vladimir@keleshev.com>'
__version__ = '0.0.2'
__license__ = 'MIT'
__keywords__ = 'docopt dispatch function adapter kwargs'
__url__ = 'https://github.com/halst/docopt-dispatch'


class DispatchError(Exception):
    pass


class Dispatch(object):

    def __init__(self):
        self._functions = OrderedDict()

    def on(self, *patterns):
        def decorator(function):
            self._functions[patterns] = function
            return function
        return decorator

    def __call__(self, *args, **kwargs):
        from docopt import docopt
        arguments = docopt(*args, **kwargs)
        for patterns, function in self._functions.items():
            if all(arguments[pattern] for pattern in patterns):
                function(**self._kwargify(arguments))
                return
        raise DispatchError('None of dispatch conditions %s is triggered'
                            % self._formated_patterns)

    @property
    def _formated_patterns(self):
        return ', '.join(' '.join(pattern)
                         for pattern in self._functions.keys())

    @staticmethod
    def _kwargify(arguments):
        kwargify = lambda string: re.sub('\W', '_', string).strip('_')
        return dict((kwargify(key), value) for key, value in arguments.items())


dispatch = Dispatch()

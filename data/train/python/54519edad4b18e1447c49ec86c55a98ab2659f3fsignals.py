"""Define helpers for Django signals"""

from django.dispatch import receiver as _receiver

from ctflex.constants import APP_NAME


def _default_dispatch_uid(receiver):
    return '{}.{}'.format(APP_NAME, receiver.__name__)


def unique_receiver(*args, **kwargs):
    """Decorate by wrapping `django.dispatch.receiver` to set `dispatch_uid` automatically

    Purpose:
        This decorator eliminates the need to set `dispatch_uid` for a Django
        receiver manually. You would want to set `dispatch_uid` to prevent a
        receiver from being run twice.

    Usage:
        Simply substitute this decorator for `django.dispatch.receiver`. If
        you define `dispatch_uid` yourself, this decorator will use that
        supplied value instead of the receiver function's name.

    Implementation Notes:
        - The default value for `dispatch_uid` (if you do not provide it
          yourself) is ‘ctflex’ composed with the receiver function’s name.
    """

    def decorator(receiver):
        default_dispatch_uid = _default_dispatch_uid(receiver)
        kwargs.setdefault('dispatch_uid', default_dispatch_uid)
        return _receiver(*args, **kwargs)(receiver)

    return decorator


def unique_connect(signal, receiver, *args, **kwargs):
    default_dispatch_uid = _default_dispatch_uid(receiver)
    kwargs.setdefault('dispatch_uid', default_dispatch_uid)
    signal.connect(receiver, *args, **kwargs)

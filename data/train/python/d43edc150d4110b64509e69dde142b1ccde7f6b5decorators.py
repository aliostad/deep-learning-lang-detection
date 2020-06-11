from functools import wraps

from django.utils.decorators import available_attrs


def throttling(validator):
    """
    Adds throttling validator to a function.
    """
    def decorator(view_func):

        def _throttling(self, *args, **kwargs):
            validator.validate(self.request)
            return view_func(self, *args, **kwargs)
        return wraps(view_func, assigned=available_attrs(view_func))(_throttling)

    return decorator


def throttling_all(klass):
    """
    Adds throttling validator to a class.
    """
    dispatch = getattr(klass, 'dispatch')
    setattr(klass, 'dispatch', throttling()(dispatch))
    return klass


def add_attribute_wrapper(name, value):

    def decorator(view_func):
        def _wrapper(*args, **kwargs):
            return view_func(*args, **kwargs)
        setattr(_wrapper, name, value)
        return wraps(view_func, assigned=available_attrs(view_func))(_wrapper)

    return decorator


def throttling_exempt():
    """
    Marks a function as being exempt from the throttling protection.
    """
    return add_attribute_wrapper('throttling_exempt', True)


def throttling_exempt_all(klass):
    """
    Marks a class as being exempt from the throttling protection.
    """
    dispatch = getattr(klass, 'dispatch')
    setattr(klass, 'dispatch', throttling_exempt()(dispatch))
    return klass


def hide_request_body():
    """
    Marks a function as being exempt from storing request base to DB.
    """
    return add_attribute_wrapper('hide_request_body', True)


def hide_request_body_all(klass):
    """
    Marks a class as being exempt from storing request base to DB.
    """
    dispatch = getattr(klass, 'dispatch')
    setattr(klass, 'dispatch', hide_request_body()(dispatch))
    return klass


def log_exempt():
    """
    Marks a function as being exempt from whole log.
    """
    return add_attribute_wrapper('log_exempt', True)


def log_exempt_all(klass):
    """
    Marks a class as being exempt from whole log.
    """
    dispatch = getattr(klass, 'dispatch')
    setattr(klass, 'dispatch', log_exempt()(dispatch))
    return klass

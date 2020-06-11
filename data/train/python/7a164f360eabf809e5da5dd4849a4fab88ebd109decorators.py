from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django.utils.decorators import method_decorator


def author_or_moderator_required_view(cls):
    """Decorates `cls.dispatch` class method to require the author or
    a moderator.
    """
    original_dispatch = cls.dispatch

    @method_decorator(login_required())
    def decorated_dispatch(self, request, *args, **kwargs):
        submission = self.get_object()
        if (
                request.user.is_superuser or
                submission.is_author(request.user) or
                submission.zone.is_moderator(request.user)
            ):
            return original_dispatch(self, request, *args, **kwargs)
        else:
            raise PermissionDenied

    cls.dispatch = decorated_dispatch
    return cls

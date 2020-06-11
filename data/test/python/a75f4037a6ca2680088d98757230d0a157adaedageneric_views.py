from django.contrib.auth.decorators import permission_required
from django.views.generic.base import View


class AuthMixin(object):

    required_permissions = []

    def get_required_permissions(self, request):
        return self.required_permissions

    def dispatch(self, request, *args, **kwargs):
        dispatch = super(AuthMixin, self).dispatch
        required_permissions = self.get_required_permissions(request)

        for required_permission in required_permissions:
            dispatch = permission_required(required_permission)(dispatch)

        return dispatch(request, *args, **kwargs)

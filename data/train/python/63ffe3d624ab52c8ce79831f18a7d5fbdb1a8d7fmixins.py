from django.shortcuts import redirect


class NoAuthenticated(object):
    def dispatch(self, request, *args, **kwargs):
        if not request.user.is_authenticated():
            return redirect('/users/login')
        return super(NoAuthenticated, self).dispatch(request, *args, **kwargs)


class Authenticated(object):
    def dispatch(self, request, *args, **kwargs):
        if request.user.is_authenticated():
            return redirect('profile')
        return super(Authenticated, self).dispatch(request, *args, **kwargs)

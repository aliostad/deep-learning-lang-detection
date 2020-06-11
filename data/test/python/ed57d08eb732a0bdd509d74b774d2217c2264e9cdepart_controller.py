from django.shortcuts import render
from django.core.context_processors import csrf
from django.contrib.auth.decorators import login_required
import webapp.repository.depart_repository as depart_repository
import webapp.repository.user_repository as user_repository

### departs page
@login_required(login_url="/login/")
def departs(request):
    departs = depart_repository.getAllDeparts()
    users = user_repository.getAllUsers()
    args = {"departs": departs, "users": users}
    args.update(csrf(request))
    return render(request, 'departs/layout.html', args)
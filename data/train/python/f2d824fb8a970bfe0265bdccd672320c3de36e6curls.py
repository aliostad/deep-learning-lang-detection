from django.conf.urls.defaults import *

from diagoras.users.views import *
from diagoras.secry.views import *


urlpatterns = patterns('',
    (r'^$', usersMain),
    (r'^secry/', include('diagoras.secry.urls')),
    (r'^manage/$', manage),
    (r'^manage/new/$', add_user),
    (r'^manage/edit/$', edit_user),
    (r'^profile/$', profile),
    (r'^messages/$', messages),
    (r'^messages/(\d+)/$', messageDetails),
    (r'^messages/forward/$', forwardMessages),
    (r'^messages/forward/edit/(\d+)/$', editForward),
    (r'^messages/forward/add/$', addForward),
)

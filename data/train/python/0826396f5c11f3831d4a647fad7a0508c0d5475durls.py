from admin.views import AdminDashBoard, AdminLogin, AdminLogout,\
    AdminAppController, AdminAppAjaxController, AdminWidgetController
from django.conf.urls import patterns, url


urlpatterns = patterns('',
    url(r'^$', AdminDashBoard.as_view(), name='admin_homepage'),
    url(r'^/login', AdminLogin.as_view(), name='admin_login'),
    url(r'^/logout', AdminLogout.as_view(), name='admin_logout'),
    url(r'^/app/ajax/(?P<appl>\w+)/(?P<controller>\w+)/(?P<action>\w+)', AdminAppAjaxController.as_view()),
    url(r'^/app/(?P<appl>\w+)/(?P<controller>\w+)/(?P<action>\w+)', AdminAppController.as_view()),
    url(r'^/widgets/(?P<appl>\w+)/(?P<controller>\w+)', AdminWidgetController.as_view()),
)

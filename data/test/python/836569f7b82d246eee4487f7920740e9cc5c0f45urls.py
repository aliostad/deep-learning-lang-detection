from django.conf.urls import patterns, url

from stucampus.dreamer.views import *

urlpatterns = [
    url(r'^joinus/?$', SignUp.as_view(),name='joinus'),
    url(r'^login_redirect/?$',login_redirect,name='login_redirect'),
    url(r'^detail/?$',detail,name='detail'),
    url(r'^add/?$', AddRegisterView.as_view(), name='add'),
    url(r'^manage/situation/(?P<grade>\d*)/?$', show_situation, name='show_situation'),
    url(r'^manage/?$', alllist, name='list'),
    url(r'^manage/delete/?$', delete, name='delete'),
    url(r'^manage/search/?$', search, name='search'),
    url(r'^manage/modify/?$', ModifyRegisterView.as_view(), name='modify'),
]


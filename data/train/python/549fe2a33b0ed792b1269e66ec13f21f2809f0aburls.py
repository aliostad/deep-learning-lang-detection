from django.conf.urls.defaults import *


urlpatterns = patterns('',
                       (r'^to_reg/$','user_manage.views.to_reg'),
                       (r'^reg/$','user_manage.views.reg'),
                       (r'^login/$','user_manage.views.login'),
                       (r'^logout/$','user_manage.views.logout'),
                       (r'^user_center/$','user_manage.views.user_center'),
                       (r'^to_mod_pass/$','user_manage.views.to_mod_pass'),
                       (r'^mod_pass/$','user_manage.views.mod_pass'),
                       (r'^to_mod_contact/$','user_manage.views.to_mod_contact'),
                       (r'^mod_contact/$','user_manage.views.mod_contact'),
                       (r'^to_sendmail/$','user_manage.views.to_sendmail'),
                       (r'^sendmail/$','user_manage.views.sendmail'),
                       )

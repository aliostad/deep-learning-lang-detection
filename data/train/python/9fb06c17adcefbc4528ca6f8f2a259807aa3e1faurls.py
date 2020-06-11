# -*- coding: UTF-8 -*-
from django.conf.urls import patterns, url
from petfarm.views import manage_home_view,manage_pet_farm_mod_view,manage_pet_farm_pic_upload_view,manage_nestofpet_add_view
from petfarm.views import manage_validate_view,manage_pwdforgot_view,manage_regist_picadd_view,manage_regist_view,address_handle_view,manage_nestofpet_mod_view,manage_nestofpet_pic_upload_view
urlpatterns = patterns(
                       '',
                       url(r'^$',manage_home_view),
                       url(r'^regist/$',manage_regist_view),
                       url(r'^regist/picadd/$',manage_regist_picadd_view),
                       url(r'^validate/$', manage_validate_view),
                       url(r'^pwdforgot/$',manage_pwdforgot_view),
                       url(r'^nestofpet/add/$',manage_nestofpet_add_view),
                       url(r'^nestofpet/mod/$',manage_nestofpet_mod_view),
                       url(r'^nestofpet/picadd/upload/$',manage_nestofpet_pic_upload_view),
                       url(r'^petfarm/mod/$',manage_pet_farm_mod_view),
                       url(r'^petfarm/address/',address_handle_view),
                       url(r'^petfarm/picadd/upload/$',manage_pet_farm_pic_upload_view),
                       )
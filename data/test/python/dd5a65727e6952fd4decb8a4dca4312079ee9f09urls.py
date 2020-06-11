# -*- coding: UTF-8 -*-
from django.conf.urls import patterns, url
from manager.views import manage_verifyinfo_view,manage_verify_view,manage_config_view,manage_knowledge_mode_view,manage_supplie_add_view,manage_supplie_mod_view,address_handle_view,manage_home_view,manage_ad_select_view,manage_pet_farm_add_view,manage_ad_add_view,manage_ad_del_view,manage_ad_pic_upload_view,manage_ad_picpre_view
urlpatterns = patterns(
                       '',
                       url(r'^$',manage_home_view),
                       url(r'^ad/add/$',manage_ad_add_view),
                       url(r'^ad/del/$',manage_ad_del_view),
                       url(r'^ad/del/adtypeselect/$',manage_ad_select_view),
                       url(r'^ad/picadd/upload/$',manage_ad_pic_upload_view),
                       url(r'^ad/picadd/preupload/$',manage_ad_picpre_view),
                       url(r'^supplie/add/$',manage_supplie_add_view),
                       url(r'^supplie/mod/$',manage_supplie_mod_view),
                       url(r'^petfarm/add/$',manage_pet_farm_add_view),
                       url(r'^petfarm/address/',address_handle_view),
                       url(r'^knowledge/mod/',manage_knowledge_mode_view),
                       url(r'^verify/',manage_verify_view),
                       url(r'^verifyinfo/',manage_verifyinfo_view),
                       url(r'^config/(?P<who>[^/]*)/$',manage_config_view),
                       )
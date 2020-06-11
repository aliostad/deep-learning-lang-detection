'''
Created on 2013-1-29

@author: lcy
'''
from django.conf.urls import url, patterns
urlpatterns = patterns('corporation.views',
    url(r'^my_corporations_news/$','my_corporations_news'),
    url(r'^my_corporations_reply/$','my_corporations_reply'),
    url(r'^my_corporations_creat/$','my_corporations_creat'),
    url(r'^creat_corporation/$', 'creat_corporation'),
    url(r'^(\d+)/$', 'redirect_to_topics'),
    url(r'^(\d+)/topics/$','visit_corporation_topics'),
    url(r'^(\d+)/structure/$','visit_corporation_structure'),
    url(r'^(\d+)/activity/$','visit_corporation_activity'),
    url(r'^(\d+)/activity/(\d+)/$','showactivity'),
    url(r'^(\d+)/watch/$','watch_corporation'),
    url(r'^(\d+)/cancle_watch/$','cancle_watch_corporation'),
    url(r'^(\d+)/topic/(\d+)/$', 'showtopic'),
    url(r'^(\d+)/topic_inactive/$','topic_inactive'),
    url(r'^(\d+)/ask/$','ask_for_admin'),
    url(r'^(\d+)/manage_edit/$','corporation_manage_edit'),
    url(r'^(\d+)/manage_members/$','corporation_manage_members'),
    url(r'^(\d+)/manage_department/$','corporation_manage_department'),
    url(r'^(\d+)/manage_advance/$','corporation_manage_advance'),
    url(r'^(?P<corporation_url_number>\d+)/promote/(?P<user_url_number>\d+)/$','promote'),
    url(r'^(?P<corporation_url_number>\d+)/demote/(?P<user_url_number>\d+)/$','demote'),
    url(r'^(?P<corporation_url_number>\d+)/kick_out/(?P<user_url_number>\d+)/$','kick_out'),
    url(r'^(?P<corporation_url_number>\d+)/approve/(?P<user_url_number>\d+)/$', 'approve'),
    url(r'^(?P<corporation_url_number>\d+)/delete/(?P<user_url_number>\d+)/$', 'delete'),
)
from django.conf.urls.defaults import *

urlpatterns = patterns('portal.polls.views',
    (r'^$', 'index'),
    (r'^poll_save/$', 'poll_save'),
    (r'^poll_edit/(?P<id>.+)/$', 'poll_save'),
    (r'^poll_detail/(?P<id>.+)/$', 'poll_detail'),
    (r'^group_save/$', 'group_save'),
    (r'^group_edit/(?P<id>.+)/$', 'group_save'),
    (r'^question_save/$', 'question_save'),
    (r'^question_edit/(?P<id>.+)/$', 'question_save'),
    (r'^choice_save/$', 'choice_save'),
    (r'^choice_edit/(?P<id>.+)/$', 'choice_save'),
    (r'^answer/(?P<id>.+)/$', 'answer'),
    (r'^send_mail/(?P<id>.+)/$', 'send_mail'),
    (r'^report/(?P<id>.+)/$', 'report'),
)
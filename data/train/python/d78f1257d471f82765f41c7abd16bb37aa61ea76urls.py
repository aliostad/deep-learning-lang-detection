# coding: utf-8
from django.conf.urls import url

from tool_bar.views import (index, forum_edit, forum_manage, forum_serialize, forum_create, user_manage, user_edit,
                            topic_edit, topic_manage, category_create, category_manage, category_edit, category_serialize,
                            user_data_serialize
                            )


urlpatterns = [
    url(r'^$', index, name='index'),
    url(r'^category/create$', category_create, name='category_create'),
    url(r'^category/all/$', category_manage, name='category_manage'),
    url(r'^category/all/serialize/$', category_serialize, name='category_serialize'),
    url(r'^category/(?P<category_id>\d+)/edit$', category_edit, name='category_edit'),
    url(r'^forum/all/$', forum_manage, name='forum_manage'),
    url(r'^forum/create/$', forum_create, name='forum_create'),
    url(r'^forum/(?P<forum_id>\d+)/edit/$', forum_edit, name='forum_edit'),
    url(r'^forum/all/data_serialize/$', forum_serialize, name='forum_serialize'),
    url(r'^topic/manage$', topic_manage, name='topic_manage'),
    url(r'^topic/(?P<topic_id>\d+)/edit$', topic_edit, name='topic_edit'),
    url(r'^user/all/$', user_manage, name='user_manage'),
    url(r'^user/(?P<user_id>\d+)/edit$', user_edit, name='user_edit'),
    url(r'^user/all/data_serialize/$', user_data_serialize, name='user_serialize'),
    ]
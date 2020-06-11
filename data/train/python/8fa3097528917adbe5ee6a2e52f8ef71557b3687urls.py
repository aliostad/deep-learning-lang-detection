# coding=utf-8
from django.conf.urls import url
from manage_rss import views

from manage_rss.views_dir.article_view import get_rss_article_view, \
    pub_article_view, \
    set_publishable_status_view, get_categories_view, set_editable_status_view
from manage_rss.views_dir.rss_view import unpub_article_feed
from manage_rss.views_dir.sent_to_ereader_view import sent_rss_to_ereader_view

urlpatterns = [
    # 获取google alert的rss链接的文章并保存
    # 例如 http://127.0.0.1:8000/manage_rss/get_rss_article/1
    url(r'^get_rss_article/(?P<group_id>[-\w]+)$', get_rss_article_view,
        name='grab_article_of_group'),

    # 使用下载到本地Article数据表中的文章生成RSS
    # 例如 http://127.0.0.1:8000/manage_rss/acmilan/rss/
    url(r'^(?P<group_slug>[-\w]+)/rss/$', unpub_article_feed(),
        name='group_rss_url'),

    # todo 查看保存到本地的单篇文章
    # 例如 http://127.0.0.1:8000/manage_rss/article/5/
    url(r'^article/(?P<article_id>\d+)/$', views.article_view,
        name='article_url'),

    # 设置文章的publishable_status
    # 例如 http://127.0.0.1:8000/manage_rss/set_publishable_status/5/1/
    url(
        r'^set_publishable_status/(?P<article_id>\d+)/('
        r'?P<publishable_status>\w+)/$',
        set_publishable_status_view,
        name='set_publishable_status_url'),

    # 设置文章的editable_status
    # 例如 http://127.0.0.1:8000/manage_rss/set_editable_status/5/1/
    url(r'^set_editable_status/(?P<article_id>\d+)/(?P<editable_status>\w+)/$',
        set_editable_status_view,
        name='set_editable_status_url'),

    # 发布文章
    # 例如 http://127.0.0.1:8000/manage_rss/pub_article/1/5/
    url(r'^pub_article/(?P<site_id>\d+)/(?P<article_id>\d+)/$',
        pub_article_view, name='pub_article_url'),

    # 获取site_id的所有category
    # 例如 http://127.0.0.1:8000/manage_rss/get_categories/1/
    url(r'^get_categories/(?P<site_id>\d+)/$', get_categories_view),

    # 将所有group的rss链接里的文章发送到eReader
    # 例如 http://127.0.0.1:8000/manage_rss/sent_rss_to_ereader_view/
    url(r'^sent_rss_to_ereader_view/$', sent_rss_to_ereader_view),

]

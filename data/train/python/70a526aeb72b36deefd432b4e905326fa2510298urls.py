#coding=utf-8
from django.conf.urls import patterns, include, url

from app import views, back_manage, front_manage,user

urlpatterns = patterns('',
    #
    url(r'^test/$', views.test, name='test'),
    url(r'^add/$', views.add, name='add'),
    url(r'^phpmyadmin/$', views.phpmyadmin, name='phpmyadmin'),

    #用户系统
    url(r'^user/(?P<article_id>[\w\-]+)/$', user.index, name='user_index'),
    #url(r'^(?P<username>[\w\-]+)/$', front_manage.index2, name='index2'),
    
    #博客前台url
    url(r'^register/$', front_manage.register, name='register'),
    url(r'^login/$', front_manage.user_login, name='user_login'),
    url(r'^$', front_manage.index, name='index'),
    #url(r'^index2/$', front_manage.index2, name='index2'),
    #url(r'^(?P<username>[\w\-]+)/$', front_manage.user_index, name='user_index'),       #不同的用户登录
    url(r'^all_article/$', front_manage.all_article, name='all_article'),
    url(r'^category/$', front_manage.category, name='category'),
    url(r'^article/$', front_manage.article, name='article'),
    url(r'^essays/$', front_manage.essays, name='essays'),
    url(r'^all_essays/$', front_manage.all_essays, name='all_essays'),
    url(r'^commit_comment/$', front_manage.commit_comment, name='commit_comment'),
    
    url(r'^album/$', front_manage.album, name='album'),

    url(r'^message/$', front_manage.message, name='message'),
    url(r'^commit_message/$', front_manage.commit_message, name='commit_message'),
    url(r'^author/$', front_manage.author, name='author'),
    url(r'^subscribe/$', front_manage.subscribe, name='subscribe'),
    url(r'^collect/$', front_manage.collect, name='collect'),

    #博客后台url
    url(r'^logout/$', back_manage.user_logout, name='user_logout'),
    url(r'^admin/$', back_manage.admin, name='admin'),
    url(r'^change_password/$', back_manage.change_password, name='change_password'),
    #分类管理
    url(r'^admin/category_manage/$', back_manage.category_manage, name='category_manage'),
    url(r'^admin/add_category/$', back_manage.add_category, name='add_category'),
    url(r'^admin/del_category/$', back_manage.del_category, name='del_category'),
    #文章管理
    url(r'^admin/article_manage/$', back_manage.article_manage, name='article_manage'),
    url(r'^admin/add_article/$', back_manage.add_article, name='add_article'),
    url(r'^admin/edit_article/$', back_manage.edit_article, name='edit_article'),
    url(r'^admin/del_article/$', back_manage.del_article, name='del_article'),
    #随笔管理
    url(r'^admin/essays_manage/$', back_manage.essays_manage, name='essays_manage'),
    url(r'^admin/add_essays/$', back_manage.add_essays, name='add_essays'),
    url(r'^admin/edit_essays/$', back_manage.edit_essays, name='edit_essays'),
    url(r'^admin/del_essays/$', back_manage.del_essays, name='del_essays'),
    #评论管理
    url(r'^admin/comment_manage/$', back_manage.comment_manage, name='comment_manage'),
    url(r'^admin/find_comment/$', back_manage.find_comment, name='find_comment'),
    url(r'^admin/del_comment/$', back_manage.del_comment, name='del_comment'),
    #留言管理
    url(r'^admin/message_manage/$', back_manage.message_manage, name='message_manage'),
    url(r'^admin/find_message/$', back_manage.find_message, name='find_message'),
    url(r'^admin/del_message/$', back_manage.del_message, name='del_message'),
    #相册管理
    url(r'^admin/album_manage/$', back_manage.album_manage, name='album_manage'),
    url(r'^admin/add_album/$', back_manage.add_album, name='add_album'),
    #友情链接管理
    url(r'^admin/link_manage/$', back_manage.link_manage, name='link_manage'),
    url(r'^admin/add_link/$', back_manage.add_link, name='add_link'),
    #url(r'^admin/advertisement_manage/$', back_manage.advertisement_manage, name='advertisement_manage'),

    url(r'^admin/user_setting/$', back_manage.user_setting, name='user_setting'),
    url(r'^admin/data_backup/$', back_manage.data_backup, name='data_backup'),
    url(r'^admin/data_restore/$', back_manage.data_restore, name='data_restore'),
    #url(r'^admin/clean_cache/$', back_manage.clean_cache, name='clean_cache'),
)

























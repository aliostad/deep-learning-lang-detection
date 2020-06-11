#coding=utf8
"""
url规则：
统一的url，需要以/结尾
带参数的url，以参数结尾，不带/
"""
from django.conf.urls.defaults import patterns

# common
urlpatterns = patterns('ymgweb.views',
    (r'^$', 'home'),
    (r'^/$', 'home'),
    #ajax
    (r'^home_best_humor/$', 'home_best_humor'),
    (r'^home_best_riddle/$', 'home_best_riddle'),
    (r'^home_best_iq/$', 'home_best_iq'),
    (r'^digg/(?P<type>\d*)/(?P<id>\d*)$', 'digg'),
    (r'^bury/(?P<type>\d*)/(?P<id>\d*)$', 'bury'),
)
# site
urlpatterns += patterns('ymgweb.site.views',
    (r'^site/(?P<template>\w*)/$', 'site'),
)
# manage
urlpatterns += patterns('ymgweb.manage.views',
    (r'^manage/change/$', 'change'),
    (r'^manage/url_list/$', 'url_list'),
    (r'^manage/style_center/$', 'style_center'),
    (r'^manage/$', 'index'),
    #list
    (r'^manage/humor_data/$', 'humor_data', {'page_id':'1'}),
    (r'^manage/humor_data/(?P<page_id>\d*)$', 'humor_data'),
    #(r'^manage/humor_edit/(?P<humor_id>\d*)$', 'humor_edit'),
    (r'^manage/humor_delete/(?P<humor_id>\d*)$', 'humor_delete'),
    (r'^manage/iq_data/$', 'iq_data', {'page_id':'1'}),
    (r'^manage/iq_data/(?P<page_id>\d*)$', 'iq_data'),
    #(r'^manage/iq_edit/(?P<iq_id>\d*)$', 'iq_edit'),
    (r'^manage/iq_delete/(?P<iq_id>\d*)$', 'iq_delete'),
    (r'^manage/riddle_data/$', 'riddle_data', {'page_id':'1'}),
    (r'^manage/riddle_data/(?P<page_id>\d*)$', 'riddle_data'),
    #(r'^manage/riddle_edit/(?P<riddle_id>\d*)$', 'riddle_edit'),
    (r'^manage/riddle_delete/(?P<riddle_id>\d*)$', 'riddle_delete'),
    #edit
    (r'^manage/content_edit/(?P<content_id>\d*)$', 'content_edit'),

    (r'^manage/promotion/$', 'promotion'),
    (r'^manage/add_promotion/$', 'add_promotion'),
    (r'^manage/edit_promotion/(?P<promotion_id>\d*)$', 'edit_promotion'),
    (r'^manage/delete_promotion/(?P<promotion_id>\d*)$', 'delete_promotion'),
)
# user
urlpatterns += patterns('ymgweb.user.views',
    (r'^user/join/$', 'join'),
    (r'^user/join_success/$', 'join_success'),
    (r'^user/login/$', 'login'),
    (r'^user/logout/$', 'logout'),
    (r'^user/edit/$', 'edit'),
)
# category
urlpatterns += patterns('ymgweb.category.views',
    (r'^category/add/$', 'add'),
)
# article
urlpatterns += patterns('ymgweb.article.views',
    (r'^article/$', 'list', {'page_id':'1'}),
    (r'^article/add/$', 'add'),
    (r'^article/list/(?P<page_id>\d*)', 'list'), #如果page_id部分传入abc，则传入view为空字符串，研究下
    (r'^article/view/(?P<article_id>\d*)', 'view'), # the same as before one
    (r'^article/edit/(?P<article_id>\d*)', 'edit'), # the same as before one
)
# humor
urlpatterns += patterns('ymgweb.humor.views',
    (r'^humor/$', 'index'),
    (r'^humor/latest/$', 'latest', {'page_id':'1'}),
    (r'^humor/latest/(?P<page_id>\d*)$', 'latest'),
    (r'^humor/add/$', 'add'),
    (r'^humor/view/(?P<humor_id>\d*)', 'view'),
    #(r'^humor/edit/(?P<humor_id>\d*)', 'edit'),
)
# iq
urlpatterns += patterns('ymgweb.iq.views',
    (r'^iq/$', 'index'),
    (r'^iq/latest/$', 'latest', {'page_id':'1'}),
    (r'^iq/latest/(?P<page_id>\d*)', 'latest'),
    (r'^iq/add/$', 'add'),
    (r'^iq/view/(?P<iq_id>\d*)', 'view'),
    (r'^iq/(?P<template>\w*)/$', 'iq'),
    #(r'^iq/edit/(?P<iq_id>\d*)', 'edit'),
)
# riddle
urlpatterns += patterns('ymgweb.riddle.views',
    (r'^riddle/$', 'index'),
    (r'^riddle/latest/$', 'latest', {'page_id':'1'}),
    (r'^riddle/latest/(?P<page_id>\d*)', 'latest'),
    (r'^riddle/add/$', 'add'),
    (r'^riddle/view/(?P<riddle_id>\d*)', 'view'),
    (r'^riddle/(?P<template>\w*)/$', 'riddle'),
    #(r'^riddle/edit/(?P<riddle_id>\d*)', 'edit'),
)
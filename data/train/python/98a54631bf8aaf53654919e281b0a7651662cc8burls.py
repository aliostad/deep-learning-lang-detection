#encoding:utf-8
from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

import settings
from Index.views import index, rules, contact, market
from User.views import release, logins, register, home, require, news, logouts, search, home_require, home_release
from Product.views import product_detail
from Manage.views import *
urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'SHM.views.home', name='home'),
    # url(r'^SHM/', include('SHM.foo.urls')),
    url(r'^$', index),
    url(r'^rules$', rules),
    url(r'^contact$', contact),                    # 联系我们
    url(r'^market$', market),                      # 二手市场
    url(r'^release$', release),                    # 用户发布页面
    url(r'^require$', require),                    # 用户求购页面
    url(r'^news$', news),                          # 用户信息
    url(r'^logout$', logouts),                     # 登出
    url(r'^login$', logins),                       # 登陆
    url(r'^register$', register),                  # 注册
    url(r'^search$', search),                      # 查找
    
    #manage page
    url(r'^manage$', manage),
    url(r'^manage/product_to_buy$', manage_buy),   # 用户求购
    url(r'^manage/product_to_sell$', manage_sell), # 用户需求
    url(r'^manage/advice$', manage_advice),        # 用户建议
    url(r'^manage/ad$', manage_ad),                # 广告管理
    url(r'^manage/news$', manage_news),            # 新闻编辑
    
    #user personal page
    url(r'^user/(?P<nid>\d+)$', home),             # 用户个人页面product/(?P<pid>\d+)$', product_detail),# 产品介绍页面    
    #user personal page
    url(r'^user/(?P<nid>\d+)/release$', home_release),             # 用户个人页面product/(?P<pid>\d+)$', product_detail),# 产品介绍页面    
    #user personal page
    url(r'^user/(?P<nid>\d+)/require$', home_require),             # 用户个人页面product/(?P<pid>\d+)$', product_detail),# 产品介绍页面
    
    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    
    url(r'^site_media/(?P<path>.*)$', 'django.views.static.serve', {'document_root' : settings.STATIC_ROOT}),
    url(r'^upload/(?P<path>.*)$', 'django.views.static.serve', {'document_root' : settings.MEDIA_ROOT}),
    
    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
)

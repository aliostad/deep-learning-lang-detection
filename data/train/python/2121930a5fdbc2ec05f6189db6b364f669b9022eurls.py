# coding: utf-8
from django.conf.urls import patterns, include, url

from django.conf import settings
from django.conf.urls.static import static

import tinytrue
import tinylog.views

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'tinytrue.views.home', name='home'),
    # url(r'^tinytrue/', include('tinytrue.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),

    url(r'^$', 'tinylog.views.home'),
    url(r'^manage$', 'tinylog.views.admin'),
    url(r'^manage/admin$', 'tinylog.views.admin'),
    url(r'^manage/login$', 'tinylog.views.login'),
    
    url(r'^manage/passage$', 'tinylog.views.mngpassage'),
    url(r'^manage/passage/new$', 'tinylog.views.mngpassage_newpassage'),
    url(r'^manage/passage/modify/(\d+)$', 'tinylog.views.mngpassage_modifypassage'),    
    url(r'^manage/passage/edit$', 'tinylog.views.edit_passage'),
    url(r'^manage/passage/delete$', 'tinylog.views.del_passage'),
    url(r'^manage/passage/backup$', 'tinylog.views.backup_passage'),
    url(r'^manage/passage/page/(\d+)$', 'tinylog.views.fetch_page_mngpassage'),
    
    url(r'^manage/comment$', 'tinylog.views.mngcomment'),
    url(r'^manage/comment/delete$', 'tinylog.views.del_comment'),
    url(r'^manage/comment/page/(\d+)$', 'tinylog.views.fetch_page_mngcomment'),
    
    url(r'^manage/catalog$', 'tinylog.views.mngcatalog'),
    url(r'^manage/catalog/(\d+)\.json$', 'tinylog.views.req_catalog'),
    url(r'^manage/catalog/new$', 'tinylog.views.new_catalog'),
    url(r'^manage/catalog/update$', 'tinylog.views.update_catalog'),
    url(r'^manage/catalog/delete$', 'tinylog.views.del_catalog'),
    
    url(r'^manage/label$', 'tinylog.views.mnglabel'),
    url(r'^manage/label/(\d+)\.json$', 'tinylog.views.req_label'),
    url(r'^manage/label/new$', 'tinylog.views.new_label'),
    url(r'^manage/label/update$', 'tinylog.views.update_label'),
    url(r'^manage/label/delete$', 'tinylog.views.del_label'),
    
    url(r'^manage/setting$', 'tinylog.views.mngsetting'),
    url(r'^manage/setting/update$', 'tinylog.views.update_setting'),
    
    url(r'^manage/password$', 'tinylog.views.mngpassword'),
    url(r'^manage/password/update$', 'tinylog.views.update_password'),
    
    url(r'^manage/game$', 'tinylog.views.mnggame'),
    url(r'^manage/game/(\d+)\.json$', 'tinylog.views.req_game'),
    url(r'^manage/game/new$', 'tinylog.views.new_game'),
    url(r'^manage/game/update$', 'tinylog.views.update_game'),
    url(r'^manage/game/delete$', 'tinylog.views.del_game'),
    
    url(r'^manage/logout$', 'tinylog.views.mnglogout'),
    
    url(r'^search$', 'tinylog.views.search'),
    
    url(r'^cat/(\d+)$', 'tinylog.views.cat_passage'),
    url(r'^label/(\d+)$', 'tinylog.views.label_passage'),
    url(r'^ar/(\d+)$', 'tinylog.views.ar_passage'),
    
    url(r'^cat/more$', 'tinylog.views.cat_more'),
    url(r'^label/more$', 'tinylog.views.label_more'),
    url(r'^ar/more$', 'tinylog.views.ar_more'),
    url(r'^comment/more$', 'tinylog.views.comment_more'),
    url(r'^commenthot/more$', 'tinylog.views.commenthot_more'),
    url(r'^hot/more$', 'tinylog.views.hot_more'),
    
    url(r'^passage/(\d+)$', 'tinylog.views.view_passage'),
    url(r'^comment/passage$', 'tinylog.views.comment_passage'),
    
    url(r'^passage/page/(\d+)$', 'tinylog.views.fetch_page_passage'),
    url(r'^comment/page/(\d+)$', 'tinylog.views.fetch_page_comment'),
    url(r'^hot/page/(\d+)$', 'tinylog.views.fetch_page_hot'),
    url(r'^commenthot/page/(\d+)$', 'tinylog.views.fetch_page_commenthot'),
    url(r'^playgame/page/(\d+)$', 'tinylog.views.fetch_page_game'),
    
    url(r'^playgame/(\d+)$', 'tinylog.views.play_game'),
    url(r'^playgame/more$', 'tinylog.views.play_game_more'),
    )
    
handler404 = tinylog.views.error404

if tinytrue.settings.DEBUG:
    urlpatterns += patterns('tinylog.views_debug',
        url(r'^test/header$', 'test_view_header'),
        url(r'^test/footer$', 'test_view_footer'),
        url(r'^test/passage$', 'test_view_passage'),
        url(r'^test/passagecount$', 'test_view_passagecount'),
        url(r'^test/gameitem$', 'test_view_gameitem'),
    )

    #静态文件
    urlpatterns += patterns('',
        url(r'^js/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT + '/js'}),
        url(r'^css/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT + '/css'}),
        url(r'^img/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT + '/img'}),
        url(r'^tinymce/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT + '/tinymce'}),
        url(r'^game/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT + '/game'}),
    )
    
if tinytrue.settings.USESAE:
    #静态文件
    urlpatterns += patterns('',
        url(r'^js/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT + '/js'}),
        url(r'^css/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT + '/css'}),
        url(r'^img/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT + '/img'}),
        url(r'^tinymce/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT + '/tinymce'}),
        url(r'^game/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT + '/game'}),
    )
    
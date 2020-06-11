from django.conf.urls import patterns, include, url
from django.contrib import admin
admin.autodiscover()

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    url(r'^$', 'Kblog.views.index', name='home'),
    url(r'^detail/', 'Kblog.views.detail', name='detail'),
    url(r'^signup/', 'Kblog.views.signup', name='signup'),
    url(r'^signin/', 'Kblog.views.signin', name='signin'),
    url(r'^code/', 'Kblog.views.code'),
    url(r'^logout/', 'Kblog.views.logout'),
    url(r'^comment_post/', 'Kblog.views.comment_post'),
    url(r'^checkaccount/', 'Kblog.views.checkaccount'),
    #url(r'^admin/', include(admin.site.urls)),

    # admin
    url(r'^manage/', 'Kblog.manages.manage'),

    url(r'^manage_article/', 'Kblog.manages.article'),
    url(r'^manage_article_write/', 'Kblog.manages.article_write'),
    url(r'^manage_article_edit/', 'Kblog.manages.article_edit'),
    url(r'^manage_article_delete/', 'Kblog.manages.article_delete'),

    url(r'^file_upload/', 'Kblog.manages.file_upload'),
    url(r'^file_delete/', 'Kblog.manages.file_delete'),

    url(r'^manage_comment/', 'Kblog.manages.comment'),
    url(r'^manage_comment_delete/', 'Kblog.manages.comment_delete'),
	
    url(r'^manage_category/', 'Kblog.manages.category'),
    url(r'^manage_category_add/', 'Kblog.manages.category_add'),
    url(r'^manage_category_edit/', 'Kblog.manages.category_edit'),
    url(r'^manage_category_delete/', 'Kblog.manages.category_delete'),
	
    url(r'^manage_attachment/', 'Kblog.manages.attachment'),
    url(r'^manage_attachment_delete/', 'Kblog.manages.attachment_delete'),
	
    url(r'^manage_user/', 'Kblog.manages.user'),
    url(r'^manage_user_add/', 'Kblog.manages.user_add'),
    url(r'^manage_user_edit/', 'Kblog.manages.user_edit'),
    url(r'^manage_user_delete/', 'Kblog.manages.user_delete'),
	
    url(r'^manage_themes/', 'Kblog.manages.themes'),
    url(r'^manage_theme_edit/', 'Kblog.manages.theme_edit'),
    url(r'^manage_theme_swich/', 'Kblog.manages.theme_swich'),
    url(r'^manage_theme_changfile/', 'Kblog.manages.theme_changefile'),
	
    url(r'^manage_profile/', 'Kblog.manages.manage_profile'),
    url(r'^manage_option/', 'Kblog.manages.manage_option'),
	
    url(r'^test/', 'Kblog.manages.test')
)


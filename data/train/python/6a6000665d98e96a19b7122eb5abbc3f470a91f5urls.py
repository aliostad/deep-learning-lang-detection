from django.conf.urls import patterns, include, url
from django.conf import settings
from django.conf.urls.static import static
from repunch import views

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',       
    #public site
    url(r'^', include('apps.public.urls')),
    
    #manage site
    url(r'^manage/account/', include('apps.accounts.urls')),
    url(r'^manage/store/', include('apps.stores.urls')),
    url(r'^manage/rewards/', include('apps.rewards.urls')),
    url(r'^manage/messages/', include('apps.messages.urls')),
    url(r'^manage/employees/', include('apps.employees.urls')),
    url(r'^manage/analysis/', include('apps.analysis.urls')),
    url(r'^manage/workbench/', include('apps.workbench.urls')),
    url(r'^manage/comet/', include('apps.comet.urls')),
    url(r'^manage/terms/$', views.manage_terms, name='manage_terms'),
    url(r'^manage/$', views.manage_login, name='manage_login'),
    url(r'^manage/logout$', views.manage_logout, name='manage_logout'),
    url(r'^manage/admin-controls$', views.manage_admin_controls, name='manage_admin_controls'),
    
    url(r'^gcm/', include('apps.gcm.urls')),
    
    # Parse Stuff
    url(r'^manage/password-reset$', 
            views.manage_parse_password_reset, 
            name='manage_parse_password_reset'),
    url(r'^manage/password-reset-complete$', 
            views.manage_parse_password_reset_complete, 
            name='manage_parse_password_reset_complete'),
    url(r'^hidden/parse-frame$',
            views.manage_parse_frame, 
            name='manage_parse_frame'),
    url(r'^invalid-link$',
            views.manage_parse_invalid_link, 
            name='manage_parse_invalid_link'),
            
    #### dev login
    url(r'^repunch-engineer-login/$', views.manage_dev_login,
        name='manage_dev_login'),
        
    #### cloud_logget triger
    url(r'^cloud-logger-trigger/$', views.manage_cloud_trigger,
        name='manage_cloud_trigger'),
            
    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    #url(r'^admin/', include(admin.site.urls)),
)

if settings.DEBUG:
    # static files (images, css, javascript, etc.)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

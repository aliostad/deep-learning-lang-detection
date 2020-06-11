from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    url(r'^download_shared','manage.views.download_shared'),
    url(r'^shared','manage.views.show_shared'),
	url(r'^newdir','manage.views.new_dir'),
	url(r'^delete','manage.views.delete'),
    url(r'^download','manage.views.download'),
    url(r'^manage','manage.views.upload'),
	url(r'^login', 'auth.views.login_user'),
	url(r'^register', 'auth.views.register_user'),
	url(r'^logout', 'auth.views.my_logout'),
	url(r'^', 'manage.views.upload'),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
)

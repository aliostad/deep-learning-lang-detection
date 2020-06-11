from django.conf.urls import patterns, include, url

urlpatterns = patterns('',
                       url(r'^importseriesdata$','database.views.importseriesdata'),
                       url(r'^upload$','database.views.upload'),
                       url(r'^confirm_upload$','database.views.confirm_upload'),
                       url(r'^save_methods$','database.views.save_methods'),
                       url(r'^save_sources$','database.views.save_sources'),
                       url(r'^save_variables$','database.views.save_variables'),
                       url(r'^save_sites$','database.views.save_sites'),
                       url(r'^save_datavalues$','database.views.save_datavalues'),
                       )
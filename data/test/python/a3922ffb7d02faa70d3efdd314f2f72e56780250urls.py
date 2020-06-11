from django.conf.urls import patterns, include, url

urlpatterns = patterns('',
                       url(r'^importseriesdata$','database.views.importseriesdata'),
                       url(r'^upload$','database.views.upload'),
                       url(r'^upload_methods$','database.views.upload_methods'),
                       url(r'^upload_sources$','database.views.upload_sources'),
                       url(r'^upload_variables$','database.views.upload_variables'),
                       url(r'^upload_sites$','database.views.upload_sites'),
                       url(r'^upload_datavalues$','database.views.upload_datavalues'),
                       url(r'^confirm_upload$','database.views.confirm_upload'),
                       url(r'^save_methods$','database.views.save_methods'),
                       url(r'^save_sources$','database.views.save_sources'),
                       url(r'^save_variables$','database.views.save_variables'),
                       url(r'^save_sites$','database.views.save_sites'),
                       url(r'^save_datavalues$','database.views.save_datavalues'),
                       url(r'^download_sample/(?P<name>.+)/$','database.views.download_sample'),
                       )
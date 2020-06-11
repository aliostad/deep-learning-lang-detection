from django.conf.urls.defaults import *

urlpatterns = patterns('', 
                       (r'^r/(?P<image_slug>.*)$','oneaday.views.photo'),
                       (r'^archive/(\d{4})/(\d{2})/$', 'oneaday.views.archive'),
                       (r'^order/$','oneaday.views.order'),
                       (r'^checkout/$','oneaday.views.checkout'),
                       (r'^success/$','oneaday.views.success'),
                       (r'^ipn$','oneaday.views.ipn'),
#                       (r'^manage$','oneaday.views.manage'),
                       (r'^$', 'oneaday.views.index')
                      ) 

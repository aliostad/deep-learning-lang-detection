from django.conf.urls.defaults import *

from controller.models import Experiment

info_dict = {
        'queryset' : Experiment.objects.all().order_by("queued")
        }

urlpatterns = patterns('', #controller.views',
    # Example:
     #(r'^/index', 'controller.views.index'),
     (r'^experiment/create$', 'controller.views.experiment_create'),
     (r'^experiment/(?P<object_id>\d+)/view$', 'django.views.generic.list_detail.object_detail',info_dict ),
     (r'^experiment/(?P<object_id>\d+)/plot$', 'controller.views.experiment_plot'),
     (r'^experiment/(?P<object_id>\d+)/csv$', 'controller.views.experiment_csv'),
     (r'^experiment$', 'django.views.generic.list_detail.object_list', info_dict),
     (r'^experiment/compare/', 'controller.views.compare'),
     (r'^register/', 'controller.views.user_create'),
     (r'^$', 'controller.views.index'),
)

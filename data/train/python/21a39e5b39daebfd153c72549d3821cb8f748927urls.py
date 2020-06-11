from django.conf.urls import patterns, url

from mc2.controllers.base import views


urlpatterns = patterns(
    '',
    url(
        r'^add/$',
        views.ControllerCreateView.as_view(),
        name='add'
    ),
    url(
        r'^(?P<controller_pk>\d+)/$',
        views.ControllerEditView.as_view(),
        name='edit'),
    url(
        r'^restart/(?P<controller_pk>\d+)/$',
        views.ControllerRestartView.as_view(),
        name='restart'),
    url(
        r'^delete/(?P<controller_pk>\d+)/$',
        views.ControllerDeleteView.as_view(),
        name='delete'),
    url(
        r'^(?P<controller_pk>\d+)/clone/$',
        views.ControllerCloneView.as_view(),
        name='clone'),
    url(
        r'^logs/(?P<controller_pk>\d+)/$',
        views.AppLogView.as_view(),
        name='logs'),
    url(
        r'^logs/(?P<controller_pk>\d+)/(?P<task_id>[\w\.\-]+)/(?P<path>(stderr|stdout))/$',  # noqa
        views.MesosFileLogView.as_view(), name='mesos_file_log_view'),
    url(
        r'^exists/(?P<controller_pk>\d+)/$',
        views.update_marathon_exists_json,
        name='update_marathon_exists_json'),
    url(
        r'^restarthook/(?P<controller_pk>\d+)/(?P<token>[\w-]+)/$',
        views.ControllerWebhookRestartView.as_view(),
        name='webhook_restart'),
)

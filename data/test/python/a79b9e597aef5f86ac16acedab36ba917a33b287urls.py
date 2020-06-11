from django.conf.urls import patterns, url
from django.views import generic
from microsip_web.apps.main import views

urlpatterns = patterns('',
    url(r'^$', 'microsip_web.apps.main.views.index'),
    url(r'^conexiones/$', views.conexiones_View),
    (r'^conexion/(?P<id>\d+)/', views.conexion_manageView),
    (r'^conexion/', views.conexion_manageView),
    url(r'^inicializar_tablas/$', 'microsip_web.apps.main.views.inicializar_tablas'),
    url(r'^plugins/$', views.AplicationPluginsView),
    url(r'^plugin/(?P<id>\d+)/', views.AplicationPluginManageView),
    url(r'^plugin/', views.AplicationPluginManageView),
    url(r'^plugin_delete/(?P<id>\d+)/', views.AplicationPluginDelete),
    # (r'^InventarioFisico/$', views.invetarioFisico_manageView),
    # (r'^InventarioFisico/(?P<id>\d+)/', views.invetarioFisico_manageView),
    # (r'^InventarioFisico/Delete/(?P<id>\d+)/', views.invetarioFisico_delete),
)
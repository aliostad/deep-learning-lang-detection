from django.conf.urls.defaults import patterns, include, url

from django.contrib import admin

urlpatterns = patterns('',

	url(r'^/$', 'Menu.views.index', name='index_menu'),
	url(r'^/create_menu$', 'Menu.views.create_menu', name='create_menu'),
	url(r'^/save_menu$', 'Menu.views.save_menu', name='save_menu'),
	url(r'^/save_menu/(?P<id>\d+)$', 'Menu.views.save_menu', name='save_mod_menu'),
	url(r'^/save_starter$', 'Menu.views.save_starter', name='save_starter'),
	url(r'^/save_dish$', 'Menu.views.save_dish', name='save_dish'),
	url(r'^/save_dessert$', 'Menu.views.save_dessert', name='save_dessert'),
	url(r'^/(?P<id>\d+)$', 'Menu.views.compose_menu', name='compose_menu'),
	url(r'^/modif_menu/(?P<id>\d+)$', 'Menu.views.modif_menu', name='modif_menu'),
	url(r'^/del_menu/(?P<id>\d+)$', 'Menu.views.del_menu', name='del_menu'),
)

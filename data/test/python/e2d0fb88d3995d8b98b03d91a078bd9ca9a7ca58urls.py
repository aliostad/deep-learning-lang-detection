from django.conf.urls import patterns, url

from swag import views

urlpatterns = patterns('',
	url(r'^$', views.index, name='index'),

	url(r'manage-swag/?$', views.manage_swag, name='manage-swag'),
	url(r'manage-people/?$', views.manage_people, name='manage-people'),

	url(r'edit-(?P<swag_id>\d+)/?$', views.edit_swag, name='edit-swag'),
	url(r'person-(?P<person_id>\d+)/?$', views.edit_person, name='edit-person'),

	url(r'order-(?P<person_id>\d+)-(?P<swag_id>\d+)/?$', views.order, name='order'),
	url(r'order-(?P<person_id>\d+)-(?P<swag_id>\d+)/confirm/?$', views.confirmed_order,name='confirmed-order'),
)

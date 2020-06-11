from django.conf.urls.defaults import patterns, include, url

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
from controller.HomeController import HomeController
from controller.SearchController import SearchController
from controller.RoomController import RoomController 
from controller.BookController import BookController 
from controller.ConfirmController import ConfirmController 
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'hotel.views.home', name='home'),
    # url(r'^hotel/', include('hotel.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
    url(r'^home/', HomeController.instance().execute),
    url(r'^search/', SearchController.instance().execute),
    url(r'^choose_room_type/(?P<hotel_id>.*)/$', RoomController.instance().execute),
    url(r'^booking/(?P<hotel_id>.*)/(?P<room_type>.*)/$', BookController.instance().execute),
    url(r'^booked/$', ConfirmController.instance().execute),
)

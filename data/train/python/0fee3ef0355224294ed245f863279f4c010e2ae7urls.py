from django.conf.urls.defaults import *

import views

from tastypie.api import Api
from wdd.api import *

api = Api(api_name='v1')
api.register(EntryResource())
api.register(RoomResource())
api.register(UserResource())
    

urlpatterns = patterns('',
                       
    url(r'^$',  views.IndexView.as_view(), name='index'),
                       

    url(r'^chat/rooms/$', views.RoomList.as_view(), name='room-list'),
    url(r'^chat/rooms/(?P<pk>\d+)/$', views.RoomDetail.as_view(), name='room-detail'),

    url(r'^chat/(?P<room>[\w.]+).(?P<mimetype>(json)|(html))$', views.chat, name = 'chat'),
    
    #(r'^api/', include(api.urls)),

)
from django.conf.urls import patterns, include, url

from pingapp import views, api, ping



api_auth = patterns('',
    url(r'/login$', api.AuthLogin.as_view(), name = 'api-login'),
    url(r'/logout$', api.AuthLogout.as_view(), name = 'api-logout'),
)

api_self = patterns('',
    url(r'/friends$', api.FriendSearchList.as_view(), name = 'api-friendsearchlist'),
    url(r'/requests$', api.RequestSearchList.as_view(), name = 'api-requestsearchlist'),
)

api_users = patterns('',
    url(r'/search$', api.UserSearchList.as_view(), name = 'api-usersearchlist'),
    url(r'/self', include(api_self))
)

api_register = patterns('',
    url(r'/availability$', api.Availability.as_view(), name = 'api-availability'),
    url(r'$', api.Register.as_view(), name = 'api-register'),
)

api_firebase = patterns('',
    url(r'/url$', api.FireBaseUrl.as_view(), name = 'api-firebaseurl'),
    url(r'/auth$', api.FireBaseAuth.as_view(), name = 'api-firebaseauth'),
)

api_ping = patterns('',
    url(r'/firebase', include(api_firebase)),
    url(r'/outbox$', api.PingOutbox.as_view(), name = 'api-pingoutbox'),
)

api_urls = patterns('',
    url(r'/auth', include(api_auth)),
    url(r'/users', include(api_users)),
    url(r'/register', include(api_register)),
    url(r'/ping', include(api_ping)),
)

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'ping_at_me.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^$', views.Homepage.as_view(), name = 'homepage'),
    url(r'^pingpanel$', views.Pingpanel.as_view(), name = 'pingpanel'),
    url(r'^api', include(api_urls)),
)
from django.conf.urls import patterns, include, url
from tastypie.api import Api
from album.api import UserResource, MediaResource, TweetResource
from django.conf import settings

api_v1 = Api(api_name=settings.API_VERSION)
api_v1.register(UserResource())
api_v1.register(MediaResource())
api_v1.register(TweetResource())

urlpatterns = patterns('',
                       url(r'^$', 'album.views.index'),
                       (r'^api/', include(api_v1.urls)),
                       # FIXME: Serve static files via Nginx.
                       (r'^static/(?P<path>.*)$', 'django.views.static.serve',  # @IgnorePep8
                        {'document_root': settings.STATIC_ROOT}),
                       )

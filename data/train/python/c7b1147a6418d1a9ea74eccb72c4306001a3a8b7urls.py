from django.conf.urls import patterns, include, url

from tastypie.api import Api
from resources import Video4FeaturedResource, FeaturedResource, VideoStreamResource, User4VideoResource, \
    CommentResource, LanguageResource, CategoryResource, TagResource, UserVideosResource, UserCommentsResource

#Default API for PortalZnanja
v1_api = Api(api_name='v1')
v1_api.register(Video4FeaturedResource())
v1_api.register(FeaturedResource())
v1_api.register(VideoStreamResource())
v1_api.register(User4VideoResource())
v1_api.register(CommentResource())
v1_api.register(LanguageResource())
v1_api.register(CategoryResource())
v1_api.register(TagResource())
v1_api.register(UserVideosResource())
v1_api.register(UserCommentsResource())


urlpatterns = patterns(
    '',
    url(r'^api/', include(v1_api.urls)),
    )
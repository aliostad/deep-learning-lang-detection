from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView
from tastypie.api import Api
from nox import api
from . import settings

v1_api = Api(api_name='v1')
v1_api.register(api.CreateUserResource())
v1_api.register(api.UserResource())
v1_api.register(api.EventResource())
v1_api.register(api.InviteResource())
v1_api.register(api.TextPostResource())
v1_api.register(api.ImagePostResource())
v1_api.register(api.PlacePostResource())
v1_api.register(api.PostResource())
v1_api.register(api.PostCommentResource())
v1_api.register(api.PostOpinionResource())

urlpatterns = patterns('',
url(r'^$', TemplateView.as_view(template_name="index.html")),
url(r'^api/', include(v1_api.urls)),
(r'^(?P<path>.*)$', 'django.views.static.serve', 
{'document_root': settings.MEDIA_ROOT}),
)
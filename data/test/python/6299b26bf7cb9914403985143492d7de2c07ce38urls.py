from django.conf.urls.defaults import patterns, include, url
from django.views.generic.simple import direct_to_template

from tastypie.api import Api
from mquiz.api.resources import QuizResource, UserResource, QuestionResource, RegisterResource, QuizAttemptResource
from mquiz.api.resources import QuizQuestionResource, ResponseResource, QuizPropsResource


v1_api = Api(api_name='v1')
v1_api.register(UserResource())
v1_api.register(QuizResource())
v1_api.register(QuizPropsResource())
v1_api.register(QuestionResource())
v1_api.register(QuizQuestionResource())
v1_api.register(ResponseResource())
v1_api.register(RegisterResource())
v1_api.register(QuizAttemptResource())

urlpatterns = patterns('',
    url(r'^', include(v1_api.urls)),
)
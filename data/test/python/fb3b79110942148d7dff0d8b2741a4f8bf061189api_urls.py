from django.conf.urls.defaults import *
from tastypie.api import Api

from visualize.api import StudentcodeResource
from visualize.api import ExerciseAssessResource
from visualize.api import ExercisewithJavaAssessResource
from visualize.api import ExerciseBTResource
from visualize.api import LinkedListKAExResource

api = Api(api_name='v1')
api.register(StudentcodeResource())
api.register(ExerciseAssessResource())
api.register(ExercisewithJavaAssessResource())
api.register(ExerciseBTResource())
api.register(LinkedListKAExResource())

urlpatterns = patterns('',
    (r'^', include(api.urls)),
)

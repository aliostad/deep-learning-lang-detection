from django.conf.urls.defaults import *
from tastypie.api import Api
from course.api import CourseResource, CourseInstanceResource
from userprofile.api import UserProfileResource
from exercise.api import ExerciseResource, CourseModuleResource, SubmissionResource, \
    LearningObjectResource
from opendsa.api import ExerciseResource, UserexerciseResource, ProblemlogResource, UserResource, \
    UserExerciseSummaryResource, UserDataResource, ModuleResource, UserModuleResource, CreateUserResource, \
    BugsResource      


api = Api(api_name='v1')
api.register(CourseResource())
api.register(CourseInstanceResource())
api.register(UserProfileResource())
api.register(CourseModuleResource())
api.register(SubmissionResource())
api.register(LearningObjectResource())
api.register(ExerciseResource())
api.register(UserexerciseResource())
api.register(ProblemlogResource())
api.register(UserResource())
api.register(UserExerciseSummaryResource())
api.register(UserDataResource())
api.register(ModuleResource())  
api.register(UserModuleResource()) 
api.register(CreateUserResource())
api.register(BugsResource())

urlpatterns = patterns('',
    (r'^', include(api.urls)),
)

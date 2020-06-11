from django.conf.urls.defaults import *

from tastypie.api import Api
from elections.api import ElectionResource, CandidateResource
from elections.api_v2 import ElectionV2Resource, CategoryV2Resource, QuestionV2Resource,\
							AnswerV2Resource, CandidateV2Resource, PersonalDataCandidateV2Resource,\
							BackgroundsCandidateV2Resource, PersonalDataV2Resource, BackgroundCategoryV2Resource,\
							BackgroundV2Resource, LinkV2Resource, MediaNaranjaResource, InformationSourceResource

v1_api = Api(api_name='v1')
v1_api.register(ElectionResource())
v1_api.register(CandidateResource())

v2_api = Api(api_name='v2')
v2_api.register(ElectionV2Resource())
v2_api.register(CategoryV2Resource())
v2_api.register(QuestionV2Resource())
v2_api.register(AnswerV2Resource())
v2_api.register(CandidateV2Resource())
v2_api.register(PersonalDataCandidateV2Resource())
v2_api.register(BackgroundsCandidateV2Resource())
v2_api.register(PersonalDataV2Resource())
v2_api.register(BackgroundCategoryV2Resource())
v2_api.register(BackgroundV2Resource())
v2_api.register(LinkV2Resource())
v2_api.register(MediaNaranjaResource())
v2_api.register(InformationSourceResource())

urlpatterns = patterns('',
    (r'^', include(v1_api.urls),),
    (r'^', include(v2_api.urls),),
)
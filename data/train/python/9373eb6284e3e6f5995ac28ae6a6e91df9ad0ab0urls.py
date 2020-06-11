from django.conf import settings
from django.conf.urls import patterns, include, url
from django.conf.urls.static import static
from django.contrib import admin

from tastypie.api import Api

from accounts.api import UserResource, GroupResource, ProfileResource, ObjectProfileLinkResource
# from alambic.api import RoomResource
from bucket.api import BucketResource, BucketFileResource, BucketTagResource, BucketFileCommentResource
from commons.api.usage import UsageResource, PertinenceResource
from commons.api.prestation import PrestationResource, PrestationModuleResource, SelectedModulesResource
# from deal.api import DealResource
from flipflop.api import BoardResource, ListResource, CardResource, TaskResource, LabelResource, CardCommentResource
from graffiti.api import TagResource, TaggedItemResource
from projects.api import ProjectResource, ProjectProgressRangeResource, ProjectProgressResource
from projectsheet.api import (ProjectSheetResource, ProjectSheetTemplateResource,
                              ProjectSheetQuestionAnswerResource, ProjectSheetQuestionResource, QuestionChoiceResource)
from projecttool.api import ProjectToolResource
from scout.api import (MapResource, TileLayerResource, DataLayerResource,
                       MarkerResource, MarkerCategoryResource, PostalAddressResource, PlaceResource)
from ucomment.api import CommentResource
from unisson.api import IngredientResource, EvaluationIngredientResource


admin.autodiscover()

# Build API
api = Api(api_name='v0')

# Scout
api.register(MapResource())
api.register(TileLayerResource())
api.register(MarkerResource())
api.register(DataLayerResource())
api.register(MarkerCategoryResource())
api.register(PostalAddressResource())
api.register(PlaceResource())


# Auth
api.register(UserResource())
api.register(GroupResource())
api.register(ProfileResource())
api.register(ObjectProfileLinkResource())

# Flipflop (Kanban)
api.register(BoardResource())
api.register(ListResource())
api.register(CardResource())
api.register(TaskResource())
api.register(CardCommentResource())
api.register(LabelResource())

# Bucket
api.register(BucketResource())
api.register(BucketTagResource())
api.register(BucketFileResource())
api.register(BucketFileCommentResource())

# Projects
api.register(ProjectResource())
api.register(ProjectProgressResource())
api.register(ProjectProgressRangeResource())

# Project Sheets
api.register(ProjectSheetResource())
api.register(ProjectSheetTemplateResource())
api.register(ProjectSheetQuestionAnswerResource())
api.register(ProjectSheetQuestionResource())
api.register(QuestionChoiceResource())

# Projects Tools
api.register(ProjectToolResource())

# Commons
api.register(UsageResource())
api.register(PertinenceResource())

# Unisson
api.register(IngredientResource())
api.register(EvaluationIngredientResource())

# deal
# api.register(DealResource())

# Prestation
api.register(PrestationResource())
api.register(PrestationModuleResource())
api.register(SelectedModulesResource())

# Graffiti
api.register(TagResource())
api.register(TaggedItemResource())

# ucomment
api.register(CommentResource())

# Alambic
# api.register(RoomResource())

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/', include(api.urls)),
    url(r'^bucket/', include('bucket.urls'))

)

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

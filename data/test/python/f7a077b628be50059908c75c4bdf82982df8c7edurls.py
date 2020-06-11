from copy import copy
from django.conf.urls import patterns, include, url
from tastypie.api import Api
from tastypie.resources import Resource
import collection.api
import catamidb.api
import jsonapi.api
import staging.api
import annotations.api

# monkey patch the Resource init method to remove a particularly cpu hungry deepcopy
def patched_resource__init__(self, api_name=None):
    #self.fields = deepcopy(self.base_fields)
    self.fields = {k: copy(v) for k, v in self.base_fields.iteritems()}

    if not api_name is None:
        self._meta.api_name = api_name

Resource.__init__ = patched_resource__init__

dev_api = Api(api_name='dev')
v1_api = Api(api_name='v1')

dev_api.register(collection.api.CollectionResource())
dev_api.register(catamidb.api.CampaignResource())
dev_api.register(catamidb.api.DeploymentResource())
dev_api.register(catamidb.api.PoseResource())
dev_api.register(catamidb.api.SimplePoseResource())
dev_api.register(catamidb.api.ImageResource())
dev_api.register(catamidb.api.ScientificImageMeasurementResource())
dev_api.register(catamidb.api.ScientificPoseMeasurementResource())
dev_api.register(catamidb.api.ScientificMeasurementTypeResource())

dev_api.register(jsonapi.api.UserResource())

dev_api.register(staging.api.StagingFilesResource())

dev_api.register(annotations.api.AnnotationCodeResource())
dev_api.register(annotations.api.QualifierCodeResource())
dev_api.register(annotations.api.PointAnnotationSetResource())
dev_api.register(annotations.api.PointAnnotationResource())

urlpatterns = patterns('',
                       (r'^$', 'jsonapi.views.help'),
                       (r'', include(dev_api.urls)),
                       (r'', include(v1_api.urls)),
)


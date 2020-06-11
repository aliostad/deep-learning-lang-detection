from copy import copy
from django.conf.urls import patterns, include, url
from tastypie.api import Api
from tastypie.resources import Resource
import catamidb.api
import jsonapi.api
import projects.api

# monkey patch the Resource init method to remove a particularly cpu hungry deepcopy
def patched_resource__init__(self, api_name=None):
    #self.fields = deepcopy(self.base_fields)
    #self.fields = {k: copy(v) for k, v in self.base_fields.iteritems()}
    self.fields = self.base_fields

    if not api_name is None:
        self._meta.api_name = api_name

Resource.__init__ = patched_resource__init__

dev_api = Api(api_name='dev')
v1_api = Api(api_name='v1')

dev_api.register(catamidb.api.CampaignResource())
dev_api.register(catamidb.api.DeploymentResource())
dev_api.register(catamidb.api.ImageResource())
dev_api.register(catamidb.api.ImageUploadResource())
dev_api.register(catamidb.api.CameraResource())
dev_api.register(catamidb.api.MeasurementsResource())

dev_api.register(jsonapi.api.UserResource())

dev_api.register(projects.api.ProjectResource())
dev_api.register(projects.api.ProjectResourceLite())
dev_api.register(projects.api.AnnotationSetResource())
dev_api.register(projects.api.PointAnnotationResource())
dev_api.register(projects.api.WholeImageAnnotationResource())
dev_api.register(projects.api.AnnotationSchemesResource())
dev_api.register(projects.api.AnnotationCodesResource())
dev_api.register(projects.api.QualifierCodesResource())

urlpatterns = patterns('',
                       (r'^$', 'jsonapi.views.help'),
                       (r'', include(dev_api.urls)),
                       (r'', include(v1_api.urls)),
)


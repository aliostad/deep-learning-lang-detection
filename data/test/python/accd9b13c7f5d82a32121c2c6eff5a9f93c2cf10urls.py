from tastypie.api import Api

from .api import TagResource, TopicCategoryResource, ProfileResource, \
    GroupResource, ContinentResource
from .resourcebase_api import LayerResource, MapResource, DocumentResource, \
    ResourceBaseResource, FeaturedResourceBaseResource, CountryResource, CycloneCountryResource, DroughtCountryResource

api = Api(api_name='api')

api.register(LayerResource())
api.register(MapResource())
api.register(DocumentResource())
api.register(ProfileResource())
api.register(ResourceBaseResource())
api.register(TagResource())
api.register(TopicCategoryResource())
api.register(GroupResource())
api.register(FeaturedResourceBaseResource())
#added for hazards
api.register(ContinentResource())
api.register(CountryResource())
api.register(CycloneCountryResource())
api.register(DroughtCountryResource())

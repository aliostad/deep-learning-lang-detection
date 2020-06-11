from tastypie.api import Api
from resources import RepositoryResource, PackageGenericResource, PackageGenericEduResource, PackageCinnamonResource, PackageCinnamonEduResource, PackageMateResource, PackageMateEduResource

api_01 = Api(api_name='0.1')
api_01.register(RepositoryResource())
api_01.register(PackageGenericResource())
api_01.register(PackageGenericEduResource())
api_01.register(PackageCinnamonResource())
api_01.register(PackageCinnamonEduResource())
api_01.register(PackageMateResource())
api_01.register(PackageMateEduResource())
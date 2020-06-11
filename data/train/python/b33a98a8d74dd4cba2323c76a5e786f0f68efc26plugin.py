import ckan.plugins as p
from ckan.plugins import implements

class APIPlugin(p.SingletonPlugin):
    implements(p.IRoutes, inherit=True)

    def before_map(self, map):
        # Geo map
        geo_controller = "ckanext.api.controller:GeoController"
        map.connect("/geometry/{organization_id}", controller=geo_controller, action="addition")
        map.connect("/geometry/organization/{organization_id}", controller=geo_controller, action="read")

        # Contact us map
        contact_us_controller = 'ckanext.api.controller:ContactUsController'
        map.connect("/create_contact", controller=contact_us_controller, action="addition")
        map.connect("/contact_list", controller=contact_us_controller, action="read")

        # Homepage organization map
        homepage_controller = 'ckanext.api.controller:HomepageController'
        map.connect("/homepage_organizations", controller=homepage_controller, action="read_homepage_organizations")

        return map

from ckanext.ngds.common import plugins as p
from ckanext.ngds.common import helpers as h
from ckanext.ngds.common import base
from ckanext.ngds.common import logic
from ckanext.ngds.common import dictization_functions as df

class ViewController(base.BaseController):

    def homepage_search(self):
        POST = base.request.params
        data = logic.clean_dict(df.unflatten(logic.tuplize_dict(
            logic.parse_params(POST))))
        query = ''

        if 'query' in data:
            query = data['query']

        if data['search-type'] == 'catalog_search':
            controller = 'package'
            return base.redirect(h.url_for(controller=controller, action='search',
                             q=query))
        else:
            controller = 'ckanext.mapsearch.controllers.view:ViewController'
            return base.redirect(h.url_for(controller=controller, action='render_map_search',
                             q=query))
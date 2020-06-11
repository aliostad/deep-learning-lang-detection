from ckan.plugins import SingletonPlugin, IGenshiStreamFilter, implements, IConfigurer, IRoutes
from logging import getLogger
from pylons import request
from genshi.input import HTML
from genshi.filters.transform import Transformer
import os

log = getLogger(__name__)

class SilkExtension(SingletonPlugin):
    
    implements(IConfigurer, inherit=True)
    implements(IGenshiStreamFilter, inherit=True)
    implements(IRoutes, inherit=True)
    
    def update_config(self, config):
        here = os.path.dirname(__file__)
        rootdir = os.path.dirname(os.path.dirname(here))
        our_public_dir = os.path.join(rootdir, 'ckanext',
                                      'silk', 'theme', 'public')
        template_dir = os.path.join(rootdir, 'ckanext',
                                    'silk', 'theme', 'templates')
        # set our local template and resource overrides
        config['extra_public_paths'] = ','.join([our_public_dir,
                config.get('extra_public_paths', '')])
        config['extra_template_paths'] = ','.join([template_dir,
                config.get('extra_template_paths', '')])
    
    def filter(self, stream):
        routes = request.environ.get('pylons.routes_dict')
        log.info(routes)
        if routes.get('controller') == 'package':

                stream = stream | Transformer('//ul[@class="nav nav-pills"]').append(HTML(
                    
                    '''<li class>
                        <a class href="/silk/%s">
                            <img src="/images/icons/rdf_flyer.24.png" height="16px" width="16px" alt="None" class="inline-icon ">
                            Silk
                        </a>
                    </li>''' % routes.get('id')
                    
                ))

        return stream
        
    def before_map(self, map):
        map.connect('/silk/editlinkagerules/{id}/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='edit_linkage_rules')
        map.connect('/silk/readlinkagerule/{id}/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='resource_read')
        map.connect('/silk/removelinkagerule/{id}/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='remove_linkage_rule')
        map.connect('/silk/editrestriction/{linkage_rule_id}/{dataset}', controller='ckanext.silk.controller:SilkController', action='restriction_edit')
        map.connect('/silk/editpathinput/{linkage_rule_id}/{dataset}/{path_input_id}', controller='ckanext.silk.controller:SilkController', action='path_input_edit')
        map.connect('/silk/newpathinput/{linkage_rule_id}/{dataset}', controller='ckanext.silk.controller:SilkController', action='path_input_new')
        map.connect('/silk/edittransformation/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='transformation_edit')
        map.connect('/silk/editcomparison/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='comparison_edit')
        map.connect('/silk/editaggregation/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='aggregation_edit')
        map.connect('/silk/get_resources/{value}', controller='ckanext.silk.controller:SilkController', action='get_resources')
        map.connect('/silk/get_classes/{property}/{resource_url}', controller='ckanext.silk.controller:SilkController', action='get_classes')
        map.connect('/silk/generate/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='generate')
        map.connect('/silk/getresults/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='get_results')
        map.connect('/silk/{id}/view_config/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='view_config')
        map.connect('/silk/{id}/launch/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='launch')
        map.connect('/silk/{id}/get_output/{linkage_rule_id}', controller='ckanext.silk.controller:SilkController', action='get_output')
        map.connect('/silk/{id}/{linkage_rule_id}/{object}/{object_id}', controller='ckanext.silk.controller:SilkController', action='resource_read')
        map.connect('/silk/{id}', controller='ckanext.silk.controller:SilkController', action='read')
        map.connect('/api/silk/listlinkagerules', controller='ckanext.silk.controller:ApiController', action='list_linkage_rules')
        map.connect('/api/silk/saveruleoutput', controller='ckanext.silk.controller:ApiController', action='save_rule_output')
                
        return map

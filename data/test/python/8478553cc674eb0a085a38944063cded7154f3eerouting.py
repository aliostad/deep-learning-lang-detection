"""Routes configuration

The more specific and detailed routes should be defined first so they
may take precedent over the more generic routes. For more information
refer to the routes manual at http://routes.groovie.org/docs/
"""
from pylons import config
from routes import Mapper

def make_map(config):
    """Create, configure and return the routes Mapper"""
    map = Mapper(directory=config['pylons.paths']['controllers'],
                 always_scan=config['debug'])
    map.minimization = False

    # The ErrorController route (handles 404/500 error pages); it should
    # likely stay at the top, ensuring it can always be resolved
    map.connect('/error/{action}', controller='error')
    map.connect('/error/{action}/{id}', controller='error')

    # CUSTOM ROUTES HERE
    map.resource('wmt', 'wmts')
    map.resource('publisher', 'publishers')
    map.resource('cmslayer', 'cmslayer')
    map.resource('zeitreihen', 'zeitreihen')
    map.resource('bodgrid', 'bodgrid')
    #map.resource('feedback', 'feedback')
    map.connect('/crossdomain.xml', controller='entry', action='crossdomain')
    map.connect('/clientaccesspolicy.xml', controller='entry', action='clientaccesspolicy')
    map.connect('/loader.js', controller='entry', action='loader')
    map.connect('/swisssearch', controller='swisssearch', action='index')
    map.connect('/swisssearch/geocoding', controller='swisssearch', action='index')
    map.connect('/geocatsearch', controller='gcsearch', action='search')
    map.connect("/feature/search",controller="feature", action="search")
    map.connect('/owschecker/bykvp', controller='owschecker', action='bykvp')
    map.connect('/owschecker/form', controller='owschecker', action='form')
    map.connect("/feature/bbox",controller="feature", action="bbox")
    map.connect("/feature/geometry",controller="feature", action="geometry")
    map.connect("/feature/{path_info:.*}",controller="feature", action="index")
    map.connect("/wmts/{path_info:.*}",controller="wmts", action="manager")
    map.connect("/wmts5/{path_info:.*}",controller="wmts", action="manager")
    map.connect("/wmts6/{path_info:.*}",controller="wmts", action="manager")
    map.connect("/wmts7/{path_info:.*}",controller="wmts", action="manager")
    map.connect("/wmts8/{path_info:.*}",controller="wmts", action="manager")
    map.connect("/wmts9/{path_info:.*}",controller="wmts", action="manager")
    map.connect('/checker', controller='checker', action='index')
    map.connect('/sanity', controller='checker', action='sanity')
    map.connect('/qrcodegenerator', controller='qrcodegenerator', action='qrcodegenerator')
    map.connect('/shorten', controller='shortener', action='shorten')
    map.connect('/shorten.json', controller='shortener', action='shortenjson')
    map.connect('/shorten/{id}', controller='shortener', action='decode')

    # Uncomment this line if you need the OGC proxy in your application
    map.connect('/ogcproxy', controller='ogcproxy', action='index')

    map.connect('/apiprintproxy', controller='apiprintproxy', action='index')

    map.connect('/height', controller="height", action='index')
    map.connect('/profile.csv', controller="profile", action='csv')
    map.connect('/profile.json', controller="profile", action='json')
    
    map.connect('/layers/{id}', controller="layers", action='index')
    map.connect('/layers', controller="layers", action='index')
    map.connect('/maps', controller="maps", action='index')


    map.connect('/{controller}/{action}')
    map.connect('/{controller}/{action}/{id}')

    return map

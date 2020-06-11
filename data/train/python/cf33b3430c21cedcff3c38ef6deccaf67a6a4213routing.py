"""Routes configuration

The more specific and detailed routes should be defined first so they
may take precedent over the more generic routes. For more information
refer to the routes manual at http://routes.groovie.org/docs/
"""
from routes import Mapper

def make_map(config):
    """Create, configure and return the routes Mapper"""
    map = Mapper(directory=config['pylons.paths']['controllers'],
                 always_scan=config['debug'])
    map.minimization = False
    map.explicit = False

    # The ErrorController route (handles 404/500 error pages); it should
    # likely stay at the top, ensuring it can always be resolved
    map.connect('/error/{action}', controller='error')
    map.connect('/error/{action}/{id}', controller='error')

    # CUSTOM ROUTES HERE
    map.redirect("/", "/index")
    map.redirect('/*(url)/', '/{url}',
             _redirect_code='301 Moved Permanently')

    # routes for user accounts		 
    map.connect("/login", controller='account', action='login')
    map.connect("/logout", controller='account', action='logout')
    map.connect("/register", controller='account', action='register')
    map.connect("/welcome", controller='account', action='welcome')
    map.connect("/update", controller='account', action='update')
    map.connect("/owner/{owner_uuid}", controller='vocabs', action='owner')

    # routes to static pages
    map.connect("/index", controller='webpages', action='index')
    map.connect("/about", controller='webpages', action='about')
    map.connect("/contact", controller='webpages', action='contact')
    map.connect("/help", controller='webpages', action='help')
    map.connect("/privacy", controller='webpages', action='privacy')

    # routes to create and manage vocabularies
    map.connect('/vocabs/create', controller='admin', action='create')
    map.connect('/vocabs/rename/{prefix}', controller='admin', action='rename')
    map.connect('/vocabs/generate/{prefix}', controller='admin', action='generate')
    #map.connect('/vocabs/check_conversion/{prefix}', controller='admin', action='check_conversion')
    #map.connect('/vocabs/modify_rdf/{prefix}', controller='admin', action='modify_rdf')
    #map.connect('/vocabs/convert/{prefix}', controller='admin', action='create')

    # routes to view vocabularies'     
    map.connect('/vocabs', controller='vocabs', action='index')
    map.connect('/vocabs/external/{vocab_name}', controller='vocabs', action='render_external_vocab')
    map.connect('/publish', controller='vocabs', action='publish')
    map.connect('/{vocab}', controller='vocabs', action='render_vocab')
    map.connect('/{vocab}/{filename:.*}', controller='vocabs', action='render_vocab_file')
                     
    map.connect('/{controller}/{action}')
    map.connect('/{controller}/{action}/{id}')

    return map

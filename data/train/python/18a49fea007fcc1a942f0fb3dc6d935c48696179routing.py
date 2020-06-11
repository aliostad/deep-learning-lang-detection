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


    map.connect('/browse', controller='browse', action='main')
    map.connect('/browse/page/{page}', controller='browse', action='main')

    map.connect('/browse/best', controller='browse', action='best')
    map.connect('/browse/best/page/{page}', controller='browse', action='best')

    map.connect('/browse/worst', controller='browse', action='worst')
    map.connect('/browse/worst/page/{page}', controller='browse', action='worst')

    map.connect('/browse/tags', controller='browse', action='tags')
    map.connect('/browse/tags/{tag}', controller='browse', action='tags')
    map.connect('/browse/tags/{tag}/page/{page}', controller='browse', action='tags')

    map.connect('/browse/disapproved', controller='browse', action='disapproved')
    map.connect('/browse/disapproved/page/{page}', controller='browse', action='disapproved')

    map.connect('/browse/unapproved', controller='browse', action='unapproved')
    map.connect('/browse/unapproved/page/{page}', controller='browse', action='unapproved')

    map.connect('/browse/deleted', controller='browse', action='deleted')
    map.connect('/browse/deleted/page/{page}', controller='browse', action='deleted')

    map.connect('/browse/reported', controller='browse', action='reported')
    map.connect('/browse/reported/page/{page}', controller='browse', action='reported')

    map.connect('/browse/favourites', controller='browse', action='favourites')
    map.connect('/browse/favourites/page/{page}', controller='browse', action='favourites')

    map.connect('/browse/random', controller='browse', action='random')
    map.connect('/browse/{ref_id}', controller='browse', action='view_one')

    map.connect('/search', controller='browse', action='search')
    map.connect('/search/{term}', controller='browse', action='search')
    map.connect('/search/{term}/page/{page}', controller='browse', action='search')


    map.connect('/create', controller='create', action='quote')

    map.connect('/signup', controller='account', action='create')
    map.connect('/login', controller='account', action='login')
    map.connect('/logout', controller='account', action='logout')
    map.connect('/reset_password', controller='account', action='reset_password')

    map.connect('/api/v1/quotes/{quote_id}/approve', controller='api_v1', action='approve')
    map.connect('/api/v1/quotes/{quote_id}/delete', controller='api_v1', action='delete')
    map.connect('/api/v1/quotes/{quote_id}/disapprove', controller='api_v1', action='disapprove')
    map.connect('/api/v1/quotes/{quote_id}/favourite', controller='api_v1', action='favourite')
    map.connect('/api/v1/quotes/{quote_id}/report', controller='api_v1', action='report')
    map.connect('/api/v1/quotes/{quote_id}/vote/{direction}', controller='api_v1', action='vote')

    map.connect('/', controller='home', action='main')

    map.redirect('/*(url)/', '/{url}', _redirect_code='301 Moved Permanently')

    return map

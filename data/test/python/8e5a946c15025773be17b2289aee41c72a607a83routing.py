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
    map.connect('/', controller="statements", action='index')

    map.connect('/latest-rss.xml', controller='rss', action='showLastStatementsAsRss')
    map.connect('/statement-{id}-rss.xml', controller='rss', action='showLastStatementsAsRssByStatement', id=id)
    map.connect('/config.js', controller='js', action='config')

    map.connect('/show/{id}', controller="statements", action="show")
    map.connect('/show/{id}', controller="statements", action="show")
    map.connect('/newThesis', controller="statements", action="newThesis")
    map.connect('/newArgument/{istrue}/{id}', controller="statements", action="newArgument")
    map.connect('/newArgument/{istrue}/{id}/', controller="statements", action="newArgument")
    
    map.connect('/upvote/{id}', controller="votes", action="upvote")
    map.connect('/downvote/{id}', controller="votes", action="upvote")

    
    map.connect('/about', controller="pages", action="about")
    map.connect('/about/', controller="pages", action="about")
    map.connect('/faq', controller="pages", action="faq")
    map.connect('/faq/', controller="pages", action="faq")
    
    map.connect('/login', controller="login", action='signin')
    map.connect('/login/', controller="login", action='signin')
    map.connect('/login/signin_POST', controller="login", action='signin_POST')
    
    map.connect('/logout', controller="login", action='signout')
    map.connect('/logout/', controller="login", action='signout')
    
    map.connect('/{controller}', action='index')
    map.connect('/{controller}/', action='index')
    map.connect('/{controller}/{action}')
    map.connect('/{controller}/{action}/')
    map.connect('/{controller}/{action}/{id}')
    
    return map

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
    map.connect('mapping0','/',
		controller='mainController', action='index')

    map.connect('mapping2','/message/:msg',
		controller='mainController', action='message',
		msg='')
    map.connect('mapping3','/auth',
        controller='mainController', action='auth')

    map.connect('mapping6','/login',
		controller='mainController', action='login')
    map.connect('mapping6','/logout',
		controller='mainController', action='logout')

    map.connect('mapping5','/users',
		controller='mainController', action='userList')

    map.connect('mapping3','/users/:userid',
		controller='mainController', action='users',
		userid='[nobody]')

    map.connect('mapping7','/dashboard/:username',
		controller='mainController', action='dashboard',
		username='[nobody]')
    map.connect('mapping4','/play/:userid',
		controller='mainController', action='play',
		userid='[nobody]')

    map.connect('flickrMapping', '/pictures',
        controller="flickrController", action="getPictures")

    map.connect('/{controller}/{action}')
    map.connect('/{controller}/{action}/{id}')

    return map

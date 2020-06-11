#-*- coding: utf-8 -*-
"""Routes configuration
refer to the routes manual at http://routes.groovie.org/docs/
"""

import logging
from routes import Mapper


def make_map(config):
	"""Create, configure and return the routes Mapper"""

	map = Mapper(directory=config['pylons.paths']['controllers'], always_scan=config['debug'])
	map.minimization = False
	map.explicit = False

	# The ErrorController route (handles 404/500 error pages); it should
	# likely stay at the top, ensuring it can always be resolved
	map.connect('/error/{action}', controller='error')
	map.connect('/error/{action}/{id}', controller='error')

	# CUSTOM ROUTES HERE
	map.connect('/', controller='login', action='index')
	map.connect('/{controller}/', action='index')
	map.connect('/{controller}', action='index')

	map.connect('/plugins/{id}/{id2}/{id3}', controller='plugins', action='index')
	map.connect('/plugins/{id}/{id2}', controller='plugins', action='index')
	map.connect('/plugins/{id}/', controller='plugins', action='index')
	
	map.connect('/plugui/{id}/{id2}', controller='plugui', action='index')
	map.connect('/plugui/{id}/', controller='plugui', action='index')
	
	map.connect('/{controller}/{action}/{id}/{id2}/{id3}/{id4}/')
	map.connect('/{controller}/{action}/{id}/{id2}/{id3}/{id4}')
	map.connect('/{controller}/{action}/{id}/{id2}/{id3}/')
	map.connect('/{controller}/{action}/{id}/{id2}/{id3}')
	map.connect('/{controller}/{action}/{id}/{id2}/')
	map.connect('/{controller}/{action}/{id}/{id2}')
	map.connect('/{controller}/{action}/{id}/')
	map.connect('/{controller}/{action}/{id}')
	map.connect('/{controller}/{action}/')
	map.connect('/{controller}/{action}')	 

	logging.getLogger(__name__).debug("DONE: make_routing_map")
	return map



import sys
import routes
from unukalhai.controller import register_controllers

m = routes.Mapper()
m.append_slash = True #What is the correct way to set this?

#Add additional routes here
m.connect('tag', '/tag/:id.:format', controller='quote', action='tag')
m.connect('tag', '/tag/:id', controller='quote', action='tag', format='html')

m.connect('about', '/about/', controller='home', action='about')

#Default routes, /controller/action/id and /controller/action/id.format
defaults = dict(controller='home', action='index', id=None, format='html')
m.connect(':controller/:action/:id.:format', **defaults)
m.connect(':controller/:action/:id', **defaults)
m.connect(':controller/:action.:format', **defaults)

register_controllers(m)

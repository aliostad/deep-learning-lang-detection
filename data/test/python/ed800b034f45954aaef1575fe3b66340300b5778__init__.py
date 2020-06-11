import re

def dispatch(handler):
  path = handler.request.path
  route = get_route(path)
  controller = create_controller_instance(route, handler)
  dispatch_action(controller, route['action'])

def dispatch_action(controller, action):
  action_method = getattr(controller, action, None)
  action_method()

def get_route(path):
  route = {}
  if path == '/' :
    route['controller'] = 'root'
    route['action'] = 'index'
    return route

  matches = re.search('^/(\w+)/(\w+)', path)
  if matches:
    route['controller'] = matches.group(1)
    route['action'] = matches.group(2)
  else:
    raise Exception('tenuki desu')

  return route

def create_controller_instance(route, handler):
  exec('from controller import ' + route['controller'].capitalize() + 'Controller') in globals()
  controller = eval( route['controller'].capitalize() + 'Controller' )
  return controller(route,handler)


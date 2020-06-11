from Rambler import component,outlet,load_classes
from Rambler.utils import getClass
import os,sys,pkg_resources
import routes


class HTTPMVCMapper(object):
  # Maps http requests to components and actions similar to rails

  compReg = outlet('ComponentRegistry')
  httpRequestMapper = outlet('HTTPRequestMapper')
  app       = outlet('Application')
  scheduler = outlet('Scheduler')
  
  def assembled(self):
    self.httpRequestMapper.registerLocationHandler(self)
    
    self.controller_names = []
    self.map = routes.Mapper(controller_scan=self.controller_names)
    self.map.minimization=True
    
    mod_names = ['Rambler', self.app.name] + [ext.name for ext in self.app.config.extensions]
    for mod_name in mod_names:
      mod_full_name = mod_name + ".web_controllers"
      for cls in load_classes(mod_full_name, component('WebController')):
        if hasattr(cls, "provides"):
          name = cls.provides
        else:
          name = cls.__name__
        self.compReg.addComponent(name, cls)
        controller_name = name.split('Controller',1)[0].lower()
        self.controller_names.append(controller_name)
       
      try:
        routes_mod_name = mod_full_name + '.routes'
        __import__(routes_mod_name,globals=globals(), locals=locals())
        routes_mod = sys.modules[routes_mod_name]
        routes_mod.add_routes(self.map)
      except(ImportError):
        pass

    # TODO: add some method where the requestmapper can ask this
    # component whether it wants to handle this request or not. That
    # way we can load both the FileMapper and this one at the same time
    
  def dispatch(self, request):
    match = self.map.match(environ=request.environ)
    
    if match:
      controller_name = self.camelHump(match['controller']) + "Controller"
      action = match['action']
      
      try:
        cls = self.compReg.lookup(controller_name)
      except KeyError:
        return None

      controller = cls(request)
      controller.routing = match
      
      if hasattr(controller, action):
        controller.app = self.app
        controller.action = action    
        #return (controller.process,) 
        return controller.process()
    
  def handleHTTPRequest(self, request, startResponse):
    return None
    
    path = request[PATH_INFO_KEY]
    routed = True
    controller, action = "DefaultController", "index"
   
    # TODO: Add rails routing

    m = self.controllerActionExp.match(path)
    if(m):
      #controller, action = m.groups()
      parts = m.groupdict()
      controller = parts['controller'] or controller
      action = parts['action'] or action
      controller = self.camelHump(controller) + "Controller"
    
    try:
      controllerClass = self.compReg.lookup(controller)
    except KeyError:
      routed = False
    
    if routed:  
      controller = controllerClass()
      if hasattr(controller, action):
        controller.app = self.app
        controller.request = request
        controller._startResponse = startResponse
        request['rambler.coroutine'] =  controller.process(action)
      else:
        routed = False

    if not routed:
      startResponse('404 Not found',(('Content-type', 'text/plain'),))
      return ['Page not found']

  def camelHump(self, s):
    return ''.join([part.capitalize() for part in s.split('_')])
        

from containers import ContainerController
from images import ImageController
from misc   import MiscController

import routes
import routes.middleware
import webob.dec

class Router (object):
	def __init__(self):

		self.mapper=routes.Mapper()
		self.container_controller=ContainerController()
		self.image_controller=ImageController()
		self.misc_controller=MiscController()

		#self.mapper.redirect("","/")
		
		self.mapper.connect('/containers',
				controller=self.container_controller,
				action='index',
				conditions={'method':['GET']},
		)
		self.mapper.connect('/containers/{container_id}',
				controller=self.container_controller,
				action='delete',
				conditions={'method':['DELETE']},
		)

		self.mapper.connect('/containers/{container_id}',
				controller=self.container_controller,
				action='show',
				condition={'method':['GET']},
		)

		self.mapper.connect('/containers/{container_id}',
				controller=self.container_controller,
				action='inspect',
				conditions={'method':['GET']},
		)


		self.mapper.connect('/containers',
				controller=self.container_controller,
				action='create',
				conditions={'method':['POST']},
		)
		
		self.mapper.connect('/images',
				controller=self.image_controller,
				action='index',
				conditions={'method':['GET']},
		)
		self.mapper.connect('/images/{image_id}',
				controller=self.image_controller,
				action='show',
				conditions={'method':['GET']},
		)
		self.mapper.connect('/images/{image_id}/inspect',
				controller=self.image_controller,
				action='inspect',
				conditions={'method':['GET']},
		)

		self.mapper.connect('/images',
				controller=self.image_controller,
				action='create',
				conditions={'method':['POST']},
		)
		
		self.mapper.connect('/images/{image_id}',
				controller=self.image_controller,
				action='delete',
				conditions={'method':['DELETE']},
		)

		self.mapper.connect('/info',
				controller=self.misc_controller,
				action='info',
				condition={'method':['GET']},
		)

		self.mapper.connect('/version',
				controller=self.misc_controller,
				action='version',
				condition={'method':['GET']},
		)	
		self.mapper.connect('/events',
				controller=self.misc_controller,
				action='events',
				condition={'method':['GET']},
		)
		self.router=routes.middleware.RoutesMiddleware(self._dispatch,self.mapper)

	@classmethod
	def factory(cls,global_config,**local_config):
		return cls()
	
	@webob.dec.wsgify
	def __call__(self,req):
		print req.environ
		return self.router

	@staticmethod
	@webob.dec.wsgify
	def _dispatch(req):
		match=req.environ['wsgiorg.routing_args'][1]
		if not match:
			return webob.Response('{"error" : "404 Not Found"}')
		app=match['controller']
		return app

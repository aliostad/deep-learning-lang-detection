from containers import ContainerController
from images import ImageController

import routes
import routes.middleware
import webob.dec

class Manage (object):
	def __init__(self):

		self.mapper=routes.Mapper()
		self.container_controller=ContainerController()
		self.image_controller=ImageController()

		self.mapper.connect('/containers',
				controller=self.container_controller,
				action='index',
				conditions={'method':['GET']},
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
		
		self.mapper.connect('/containers/{container_id}',
				controller=self.container_controller,
				action='delete',
				conditions={'method':['DELETE']},
		)


		self.mapper.connect('/images',
				controller=self.image_controller,
				action='index',
				conditions={'method':['GET']},
		)
		self.mapper.connect('/images/{image_id}',
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
		self.router=routes.middleware.RoutesMiddleware(self._dispatch,self.mapper)

	@classmethod
	def factory(cls,global_config,**local_config):
		return cls()
	
	@webob.dec.wsgify
	def __call__(self,req):
		return self.router

	@staticmethod
	@webob.dec.wsgify
	def _dispatch(req):
		match=req.environ['wsgiorg.routing_args'][1]
		if not match:
			return webob.Response('{"error" : "404 Not Found"}\n')
		app=match['controller']
		return app

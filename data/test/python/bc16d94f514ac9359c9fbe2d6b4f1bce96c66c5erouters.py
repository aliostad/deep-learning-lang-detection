#!/bin/python
from hydrogen.v1 import wsgi
import controllers
class Public():
	def add_routes(self,mapper):
		svmanp_controller=wsgi.Resource(controllers.VMSVManProxy())
		#mapper.resource('test','tests',controller=wsgi.Resource(controllers.Hello()))
		mapper.connect('/filedeploy',controller=svmanp_controller,action='fileDeploy')	
		mapper.connect('/fileundeploy/{id}',controller=svmanp_controller,action='fileUndeploy')
# 		mapper.connect('/svs/{id}',controller=svmanp_controller,action='svCall')
		mapper.connect('/svs/{id}',controller=svmanp_controller,action='buildSvInst',conditions=dict(method=["POST"]))
		mapper.connect('/svs/{id}/{sv_inst_id}',controller=svmanp_controller,action='svStatequery',conditions=dict(method=["GET"]))
		mapper.connect('/svs/{id}/{sv_inst_id}/suspend',controller=svmanp_controller,action='svSuspend',conditions=dict(method=["PUT"]))
		mapper.connect('/svs/{id}/{sv_inst_id}',controller=svmanp_controller,action='svClose',conditions=dict(method=["DELETE"]))
		mapper.connect('/svs/{id}/{sv_inst_id}',controller=svmanp_controller,action='svCall',conditions=dict(method=["POST"]))
		mapper.connect('/svs/{id}/{sv_inst_id}/resume',controller=svmanp_controller,action='svResume',conditions=dict(method=["PUT"]))
		mapper.connect('/svs',controller=svmanp_controller,action='closeAll',conditions=dict(method=["DELETE"]))
		
	
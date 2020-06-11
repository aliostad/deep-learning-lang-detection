# -*- coding: utf-8 -*-

""" URL Mapper for Snortmanager """

try:
	import cherrypy
	from webapp.controller.main import MainController
	from webapp.controller.rule import RuleController
	from webapp.controller.sensor import SensorController
	from webapp.controller.policy import PolicyController
	from webapp.controller.background_jobs import JobsController
except ImportError as e:
	print 'Error while importing error in', __file__
	print e
	
def initialize_routes():
    """ Maps URLs to methods and controllers.
    
    Only these URls are allowed on the network.
    """

    mapper = cherrypy.dispatch.RoutesDispatcher()
    mapper.minimization = False
    mapper.explicit = False
    mapper.append_slash = True
    
    mapper.connect('main', '/', controller = MainController(), action = 'index')

	# Dispatcher for rules
    mapper.connect('rules', '/rules/', controller = RuleController(), action = 'index')
    mapper.connect('rules', '/rules/source/', controller = RuleController(), action = 'source')
    mapper.connect('rules', '/rules/source/:id/', controller = RuleController(), action = 'source')
    mapper.connect('rules', '/rules/register/', controller = RuleController(), action = 'register_source')
    
	# Dispatcher for sensor
    mapper.connect('sensor', '/sensor/', controller = SensorController(), action = 'index')
    mapper.connect('sensor', '/sensor/addsensor/', controller = SensorController(), action = 'addsensorindex')
    mapper.connect('sensor', '/sensor/save/', controller = SensorController(), action = 'save_sensor_data')
    mapper.connect('sensor', '/sensor/get/sensor/:id/', controller = SensorController(), action = 'get_sensor_data')
    mapper.connect('sensor', '/sensor/location/add/', controller = SensorController(), action = 'add_location')
    mapper.connect('sensor', '/sensor/delete/', controller = SensorController(), action = 'delete_sensor')


    # Dispatcher for policy
    mapper.connect('policy', '/policy/', controller = PolicyController(), action = 'index')
    mapper.connect('policy', '/policy/add/', controller = PolicyController(), action = 'add_policy')
    mapper.connect('policy', '/policy/save/object/', controller = PolicyController(), action = 'save_object')
    mapper.connect('policy', '/policy/edit/policy/', controller = PolicyController(), action = 'edit_policy')
    mapper.connect('policy', '/policy/edit/policy/:id/', controller = PolicyController(), action = 'edit_policy')
    mapper.connect('policy', '/policy/edit/policy_item/:id/', controller = PolicyController(), action = 'get_policy_item')
    mapper.connect('policy', '/policy/edit/get_object/:id/', controller = PolicyController(), action = 'get_object')
    mapper.connect('policy', '/policy/edit/object/add/', controller = PolicyController(), action = 'add_object')
    mapper.connect('policy', '/policy/delete/:id', controller = PolicyController(), action = 'delete_policy')
    mapper.connect('policy', '/policy/remove_object/', controller = PolicyController(), action = 'remove_object')
    mapper.connect('policy', '/policy/edit/new_object/:id/', controller = PolicyController(), action = 'new_object')
    mapper.connect('policy', '/policy/edit_order/', controller = PolicyController(), action = 'edit_order')
    mapper.connect('policy', '/policy/edit/choose_object/', controller = PolicyController(), action = 'choose_object')
    
    #Dispatcher for background jobs
    
    mapper.connect('jobs', '/jobs/', controller = JobsController(), action='index')
    mapper.connect('jobs', '/jobs/start_job/', controller = JobsController(), action='start_job')
    mapper.connect('jobs', '/jobs/schedule/', controller = JobsController(), action='schedule')
    
    return mapper

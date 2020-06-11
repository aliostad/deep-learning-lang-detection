#-*- coding: utf-8 -*
import logging
import importlib
import inspect

from cf_service_broker import exceptions
from conf import config

def create():
	# Load the class that will handle API requests
	cfsb_handler = config.get('Service Broker', 'handler')

	print("Attempting to start with {} handler".format(cfsb_handler))

	cfsb_module_default = importlib.import_module("cf_service_broker.handlers.{handler}".format(handler="default_service_broker"))
	cfsb_module = importlib.import_module("cf_service_broker.handlers.{handler}".format(handler=cfsb_handler))

	for name, obj in inspect.getmembers(cfsb_module_default):
		if inspect.isclass(obj) and obj.__name__[-13:] == "ServiceBroker":
			cfsb_class_default = obj

	for name, obj in inspect.getmembers(cfsb_module):
		if inspect.isclass(obj) and obj.__name__[-13:] == "ServiceBroker":
			cfsb_class = obj
	try:
		if cfsb_class.__name__ == "DefaultServiceBroker":
			print "Warning: Your running DefaultServiceBroker, which probably isn't what you want"
		elif not issubclass(cfsb_class,cfsb_class_default):
			raise exceptions.InvalidServiceBroker("{classname} is not a subclass of {classname_default}".format(classname=cfsb_class.__name__,classname_default=cfsb_class_default.__name__))
	except:
		raise
	
	cfsb_object = cfsb_class()

	return cfsb_class, cfsb_object

(cfsb_class, cfsb_object) = create()

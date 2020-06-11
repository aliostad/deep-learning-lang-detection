#!/usr/bin/env python

import requests
import argparse
import json
import os
import ConfigParser
from ConfigParser import Error

dir(ConfigParser)

class paasController():

	def __init__(self):
		self.controller_file = os.path.expanduser('~/.paascontroller')
		self.config = ConfigParser.ConfigParser()
		if os.path.exists(self.controller_file):
			self.config.read(self.controller_file)
		else:
			self.config.add_section('controllers')

		self.request_headers = { 'Content-type': 'application/json' }
		
	def list_controllers(self):
		controllers = {}
		try:
			controllers = self.config.items('controllers')	
		except Exception as e: 
			pass

		print controllers

		print "Current Controllers:"
		print ""
		for controller in controllers:
			print "    Shortname: {}  - Host: {}".format(controller[0], controller[1] )
		print ""

	def get_controller(self, controller):
		try:
			return self.config.get('controllers', controller)
		except:
			print "Controller not found"
			raise Exception

	def add_controller(self, controller, hostname):
		self.config.set('controllers', controller, hostname)
		with open(self.controller_file, "wb") as configfile:
			self.config.write(configfile)

		print "Controller {} added".format(controller)

	def remove_controller(self, controller):
		output = self.config.remove_option('controllers', controller)	
		if output == True:
			print "Removed Controller {}".format(controller)
		else:
			print "Controller {} not found".format(controller)

	def create_application(self, controller, app_name):
		controller_address = self.get_controller(controller)
		payload = { "name": app_name }
		r = requests.post("{}/app/".format(controller_address), headers=self.request_headers, data = json.dumps(payload) )
		if r.status_code == 201:
			print "Application {} created".format(app_name)
			print ""
			print r.text
		else:
			print "Error creating application {}".format(app_name)

	def update_application(self, controller, app_name, **args):
		pass

	def get_application(self, controller, app_name):
		controller_address = self.get_controller(controller)
		r = requests.get("{}/app/{}".format(controller_address, app_name))
		if r.status_code == 200:
			print r.text
		else:
			print "Unable to return application data"

	def delete_application(self, controller, app_name):
		controller_address = self.get_controller(controller)
		r = requests.delete("{}/app/{}".format(controller_address, app_name))
		if r.status_code == 200:
			print "Application {} deleted".format(app_name)
		else:
			print "Unable to delete {}".format(app_name)

	def globals(self, controller):
		controller_address = self.get_controller(controller)
		r = requests.get("{}/global".format(controller_address))
		print r.status_code
		print r.text
	
	def main():
		
		pass

if __name__ == '__main__':
	paas = paasController()
	paas.add_controller("localhost", "http://127.0.0.1:8000")
	paas.list_controllers()
	paas.remove_controller("localhost")
	paas.remove_controller("localhost")

	paas.add_controller("localhost", "http://127.0.0.1:8000")
	paas.create_application("localhost", "testapp5")
	paas.create_application("localhost", "testapp5")
	paas.get_application("localhost", "testapp5")
	paas.delete_application("localhost", "testapp5")
	paas.delete_application("localhost", "testapp6")
	paas.globals("localhost")

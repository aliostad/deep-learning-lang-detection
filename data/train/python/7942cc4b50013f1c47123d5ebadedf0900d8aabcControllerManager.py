
import os
import sys
import ControllerBase
import Settings

gControllerMan = False

def GetControllerManager():
	global gControllerMan
	if gControllerMan == False:
		gControllerMan = ControllerManager()
	return gControllerMan

class ControllerManager:
	modules = {}
	controllers = {}
	
	def __init__(self):
		self.ImportAvailableController()
	
	def ImportAvailableController(self):
		controllersPath = Settings.Settings["PATH"] + "/Controllers"
		sys.path.append(controllersPath)

		for controllerName in os.listdir(controllersPath):
			if controllerName[0] != '.' and controllerName.endswith(".py"):
				controllerName = controllerName[:controllerName.find(".")]
				self.modules[controllerName] = __import__(controllerName)
				print "Loaded controller: " + controllerName

		print ""

	def StartConfiguredControllers(self):
		configPath = Settings.Settings["PATH"] + "/Config"
		sys.path.append(configPath)

		for configFile in os.listdir(configPath):
			if configFile[0] != '.' and configFile.endswith(".controller"):
				
				name = configFile[:configFile.find(".")]

				settingsFile = open(configPath + "/" + configFile, 'r')
				lines = settingsFile.readlines()
				settingsFile.close()
	
				settings = {}

				for line in lines:
					line = line.strip("\n").strip(" ")
					if len(line) > 0:
						if line[0] != '#':
							settingName = line[:line.find("=")]
							settingValue = line[line.find("=")+1:]

							settings[settingName] = settingValue
	
				if not settings.has_key("CONTROLLER"):
					print configFile + " has no CONTROLLER defined, skipping"
				elif not self.modules.has_key(settings["CONTROLLER"]):
					print settings["CONTROLLER"] + " is not a recognized controller name, skipping"
				else: 
					self.controllers[name] = self.modules[settings["CONTROLLER"]].Controller(settings)
					print "Started controller: " + settings["CONTROLLER"] + " with Config/" + configFile

		print ""

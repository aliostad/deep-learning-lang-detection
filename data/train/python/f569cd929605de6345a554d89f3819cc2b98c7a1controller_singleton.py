from incident_monitor.controller import Controller

class ControllerSingleton:

	class ControllerInstance:

		def __init__(self):
			self.dict = {}

		def get_controller(self, id):
			if id in self.dict:
				return self.dict.get(id)
			else:
				self.dict[id] = Controller()
				return self.dict.get(id)

		def destroy_controller(self, id):
			if id in self.dict:
				self.dict.pop(id)

	__instance = None

	def __init__(self):
		if ControllerSingleton.__instance is None:
			ControllerSingleton.__instance = ControllerSingleton.ControllerInstance()

		self.__dict__['_ControllerSingleton__instance'] = ControllerSingleton.__instance

	def get_controller(self, id):
		return self.__instance.get_controller(id)

	def destroy_controller(self, id):
		self.__instance.destroy_controller(id)

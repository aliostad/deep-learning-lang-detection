from Tank import Tank
from player_controller import Controller, Event

class PlayerTank(Tank):
	def __init__(self, field, data):		
		Tank.__init__(self, field, data)
		self.controller = Controller(self)
		self.controller.start()
		
	def destroy(self):
		Tank.destroy(self)
				
	def addListener(self, ports):
		return self.controller.addOutputListener(ports)
								
	def event(self, event_name, port):
		self.controller.addInput(Event(event_name, port))
			
	def update(self, delta):
		self.controller.addInput(Event("update","engine"))
		self.controller.update(delta)
		
		

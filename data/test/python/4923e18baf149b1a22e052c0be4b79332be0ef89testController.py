import unittest
import time
if __name__ == '__main__':
	import dosetenv
import scac.logic.Controller as Controller

class testLED(unittest.TestCase):

	def do_test(self, turnvalue, rv, rv_string):
		if turnvalue != None:
			self.AC.turn( turnvalue )
		for i in range(100):
			self.AC.loop()
		self.assertTrue( self.AC.getStatus() == rv )
		self.assertTrue( self.AC.getStatusString() == rv_string )

	def test_AC(self):
		self.AC = Controller.Controller()
		self.do_test(None, Controller.S_OFF,   'S_OFF')
		self.do_test(Controller.S_POWER, Controller.S_POWER, 'S_POWER')
		self.do_test(Controller.S_OFF, Controller.S_FAN_OUT, 'S_FAN_OUT')
		self.do_test(Controller.S_AC,  Controller.S_AC,      'S_AC')
		self.do_test(Controller.S_FAN, Controller.S_FAN,     'S_FAN')
		self.do_test(Controller.S_OFF, Controller.S_FAN_OUT, 'S_FAN_OUT')
		self.AC.timerfortest()
		self.do_test(Controller.S_OFF, Controller.S_OFF,     'S_OFF')

if __name__ == '__main__':
	unittest.main()

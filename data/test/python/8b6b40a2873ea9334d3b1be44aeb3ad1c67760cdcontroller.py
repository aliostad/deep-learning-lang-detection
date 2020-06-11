import unittest
 	
import org.puremvc.python.interfaces
import org.puremvc.python.patterns.observer
import org.puremvc.python.core 
import utils.controller

class ControllerTest(unittest.TestCase):
	"""ControllerTest: Test Controller Singleton"""
	def assertNotNone(self):
		"""ControllerTest: Test instance not null"""
		controller = org.puremvc.python.core.Controller.getInstance()
   		self.assertNotEqual(None, controller) 

	def assertIController(self):
		"""ControllerTest: Test instance implements IController"""
		controller = org.puremvc.python.core.Controller.getInstance()
   		self.assertEqual(True, isinstance(controller, org.puremvc.python.interfaces.IController))

	def testRegisterAndExecuteCommand(self):
 		"""ControllerTest: Test registerCommand() and executeCommand(0)"""
		controller = org.puremvc.python.core.Controller.getInstance()
		controller.registerCommand('ControllerTest', utils.controller.ControllerTestCommand)
		
		vo = utils.controller.ControllerTestVO(12)
		note = org.puremvc.python.patterns.observer.Notification('ControllerTest', vo)

		controller.executeCommand(note)
		
		self.assertEqual(True, vo.result == 24 )
  		
	def testRegisterAndRemoveCommand(self): 
		"""ControllerTest: Test registerCommand() and removeCommand()"""
		controller = org.puremvc.python.core.Controller.getInstance()
		controller.registerCommand('ControllerRemoveTest', utils.controller.ControllerTestCommand)

		vo = utils.controller.ControllerTestVO(12)
		note = org.puremvc.python.patterns.observer.Notification('ControllerRemoveTest', vo)

		controller.executeCommand(note)

		self.assertEqual(True, vo.result == 24 )

		vo.result = 0

		controller.removeCommand('ControllerRemoveTest')
		controller.executeCommand(note)

		self.assertEqual(True, vo.result == 0)
 			
	def testHasCommand(self): 
		"""ControllerTest: Test hasCommand()"""
		
		controller = org.puremvc.python.core.Controller.getInstance()
		controller.registerCommand('hasCommandTest', utils.controller.ControllerTestCommand)

		self.assertEqual(True, controller.hasCommand('hasCommandTest'))

		controller.removeCommand('hasCommandTest')

		self.assertEqual(False, controller.hasCommand('hasCommandTest'))
 			
 		
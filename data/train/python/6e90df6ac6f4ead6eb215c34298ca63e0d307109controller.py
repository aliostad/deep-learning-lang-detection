import unittest
import puremvc.interfaces
import puremvc.patterns.observer
import puremvc.core 
import utils.controller

class ControllerTest(unittest.TestCase):
    """ControllerTest: Test Controller Singleton"""
    def assertNotNone(self):
        """ControllerTest: Test instance not null"""
        controller = puremvc.core.Controller.getInstance()
        self.assertNotEqual(None, controller) 

    def assertIController(self):
        """ControllerTest: Test instance implements IController"""
        controller = puremvc.core.Controller.getInstance()
        self.assertEqual(True, isinstance(controller, puremvc.interfaces.IController))

    def testRegisterAndExecuteCommand(self):
        """ControllerTest: Test registerCommand() and executeCommand()"""
        controller = puremvc.core.Controller.getInstance()
        controller.registerCommand('ControllerTest', utils.controller.ControllerTestCommand)
        
        vo = utils.controller.ControllerTestVO(12)
        note = puremvc.patterns.observer.Notification('ControllerTest', vo)

        controller.executeCommand(note)
        
        self.assertEqual(True, vo.result == 24 )
          
    def testRegisterAndRemoveCommand(self): 
        """ControllerTest: Test registerCommand() and removeCommand()"""
        controller = puremvc.core.Controller.getInstance()
        controller.registerCommand('ControllerRemoveTest', utils.controller.ControllerTestCommand)

        vo = utils.controller.ControllerTestVO(12)
        note = puremvc.patterns.observer.Notification('ControllerRemoveTest', vo)

        controller.executeCommand(note)

        self.assertEqual(True, vo.result == 24 )

        vo.result = 0

        controller.removeCommand('ControllerRemoveTest')
        controller.executeCommand(note)

        self.assertEqual(True, vo.result == 0)
             
    def testHasCommand(self): 
        """ControllerTest: Test hasCommand()"""
        
        controller = puremvc.core.Controller.getInstance()
        controller.registerCommand('hasCommandTest', utils.controller.ControllerTestCommand)

        self.assertEqual(True, controller.hasCommand('hasCommandTest'))

        controller.removeCommand('hasCommandTest')

        self.assertEqual(False, controller.hasCommand('hasCommandTest'))

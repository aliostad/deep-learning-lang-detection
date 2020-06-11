import unittest
from puremvc_multicore.core import Controller
from puremvc_multicore.interfaces import IController
from puremvc_multicore.patterns.observer import Notification
import utils.controller


class ControllerTest(unittest.TestCase):
    """ControllerTest: Test Controller Singleton"""
    def assertNotNone(self):
        """ControllerTest: Test instance not null"""
        controller = Controller('test')
        self.assertNotEqual(None, controller)

    def assertIController(self):
        """ControllerTest: Test instance implements IController"""
        controller = Controller('test')
        self.assertEqual(True, isinstance(controller, IController))

    def testRegisterAndExecuteCommand(self):
        """ControllerTest: Test register_command() and execute_command()"""
        controller = Controller('test')
        controller.register_command('ControllerTest', utils.controller.ControllerTestCommand)

        vo = utils.controller.ControllerTestVO(12)
        note = Notification('ControllerTest', vo)

        controller.execute_command(note)

        self.assertEqual(True, vo.result == 24 )

    def testRegisterAndRemoveCommand(self):
        """ControllerTest: Test register_command() and remove_command()"""
        controller = Controller('test')
        controller.register_command('ControllerRemoveTest', utils.controller.ControllerTestCommand)

        vo = utils.controller.ControllerTestVO(12)
        note = Notification('ControllerRemoveTest', vo)

        controller.execute_command(note)

        self.assertEqual(True, vo.result == 24 )

        vo.result = 0

        controller.remove_command('ControllerRemoveTest')
        controller.execute_command(note)

        self.assertEqual(True, vo.result == 0)

    def testHasCommand(self):
        """ControllerTest: Test has_command()"""

        controller = Controller('test')
        controller.register_command('hasCommandTest', utils.controller.ControllerTestCommand)

        self.assertEqual(True, controller.has_command('hasCommandTest'))

        controller.remove_command('hasCommandTest')

        self.assertEqual(False, controller.has_command('hasCommandTest'))

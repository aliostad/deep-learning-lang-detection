import unittest
from mock import patch, call
from chaser.controller import MotorController, LEFT_KEY, RIGHT_KEY, UP_KEY, DOWN_KEY, MotorInputError


class ControllerTestCase(unittest.TestCase):

    @patch('chaser.controller.gpio')
    def test_init(self, io):
        io.OUT = True
        calls = [call(4, True), call(17, True), call(24, True), call(25, True)]
        MotorController()
        io.setup.assert_has_calls(calls)

    @patch('chaser.controller.gpio')
    def test_shut_down(self, io):
        controller = MotorController()
        io.reset_mock()
        controller.shut_down()
        calls = [call(4, False), call(17, False), call(24, False), call(25, False)]
        io.output.assert_has_calls(calls)

    @patch('chaser.controller.gpio')
    def test_left(self, io):
        controller = MotorController()
        controller.left()
        calls = [call(24, True), call(25, False)]
        io.output.assert_has_calls(calls)
        self.assertEqual(controller.state, 'left')

    @patch('chaser.controller.gpio')
    def test_left_stop(self, io):
        controller = MotorController()
        controller.turn_keys.add(LEFT_KEY)
        controller.left()
        calls = [call(24, False), call(25, False)]
        io.output.assert_has_calls(calls)
        self.assertEqual(controller.state, 'stopped')

    @patch('chaser.controller.gpio')
    def test_right(self, io):
        controller = MotorController()
        controller.right()
        calls = [call(25, True), call(24, False)]
        io.output.assert_has_calls(calls)
        self.assertEqual(controller.state, 'right')

    @patch('chaser.controller.gpio')
    def test_right_stop(self, io):
        controller = MotorController()
        controller.turn_keys.add(RIGHT_KEY)
        controller.right()
        calls = [call(25, False), call(24, False)]
        io.output.assert_has_calls(calls)
        self.assertEqual(controller.state, 'stopped')

    @patch('chaser.controller.gpio')
    def test_forward(self, io):
        controller = MotorController()
        controller.forward()
        calls = [call(4, True), call(17, False)]
        io.output.assert_has_calls(calls)
        self.assertEqual(controller.state, 'forward')

    @patch('chaser.controller.gpio')
    def test_forward_stop(self, io):
        controller = MotorController()
        controller.progress_keys.add(UP_KEY)
        controller.forward()
        calls = [call(4, False), call(17, False)]
        io.output.assert_has_calls(calls)
        self.assertEqual(controller.state, 'stopped')

    @patch('chaser.controller.gpio')
    def test_reverse(self, io):
        controller = MotorController()
        controller.reverse()
        calls = [call(17, True), call(4, False)]
        io.output.assert_has_calls(calls)
        self.assertEqual(controller.state, 'backwards')

    @patch('chaser.controller.gpio')
    def test_reverse_stop(self, io):
        controller = MotorController()
        controller.progress_keys.add(DOWN_KEY)
        controller.reverse()
        calls = [call(17, False), call(4, False)]
        io.output.assert_has_calls(calls)
        self.assertEqual(controller.state, 'stopped')

    @patch('chaser.controller.gpio')
    def test_motor(self, io):
        controller = MotorController()

        controller.motor(UP_KEY)
        calls = [call(4, True), call(17, False)]
        io.output.assert_has_calls(calls)

        io.reset_mock()
        controller.motor(DOWN_KEY)
        calls = [call(17, True), call(4, False)]
        io.output.assert_has_calls(calls)

        io.reset_mock()
        controller.motor(RIGHT_KEY)
        calls = [call(25, True), call(24, False)]
        io.output.assert_has_calls(calls)

        io.reset_mock()
        controller.motor(LEFT_KEY)
        calls = [call(24, True), call(25, False)]
        io.output.assert_has_calls(calls)

    def test_motor_bad_key(self):
        controller = MotorController()
        with self.assertRaises(MotorInputError):
            controller.motor('other')

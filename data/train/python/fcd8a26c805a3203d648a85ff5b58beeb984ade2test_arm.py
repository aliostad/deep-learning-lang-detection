from unittest import TestCase
from mock import MagicMock
from robocam.arm import Controller
from robocam.const import ACTION_TIMEOUT


class ControllerCase(TestCase):
    """Arm controller case"""

    def setUp(self):
        self._orig_init_arm = Controller._init_arm
        Controller._init_arm = MagicMock()
        self.controller = Controller()
        self.controller.arm = MagicMock()

    def tearDown(self):
        Controller._init_arm = self._orig_init_arm

    def test_perform(self):
        """Test perform"""
        self.controller.perform('test', 'asd')
        self.controller.arm.test.asd.assert_called_once_with(
            timeout=ACTION_TIMEOUT,
        )

    def test_perform_with_led(self):
        """Test perform with led"""
        self.controller.perform('led', 'off')
        self.controller.arm.led.off.assert_called_once_with()

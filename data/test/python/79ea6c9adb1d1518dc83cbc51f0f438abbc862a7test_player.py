from unittest import TestCase
from mock import patch


from pyamp.player import SweepingInterpolationControlSource


class TestSweepingInterpolationControlSource(TestCase):
    # These tests suffer a little from testing the implementation rather than
    # the general behaviour :-(

    def setUp(self):
        # We have to patch the methods that call out to gstreamer-land:
        set_patcher = patch(
            'pyamp.player.SweepingInterpolationControlSource.set',
            return_value=True)
        set_patcher.start()
        self.addCleanup(set_patcher.stop)
        unset_patcher = patch(
            'pyamp.player.SweepingInterpolationControlSource.unset')
        unset_patcher.start()
        self.addCleanup(unset_patcher.stop)

    def test_set_target(self):
        sweeping_controller = SweepingInterpolationControlSource(
            target_value=42)
        self.assertEqual(sweeping_controller._target_value, 42)
        sweeping_controller.set.assert_called_with(0, 42)
        sweeping_controller.set_target(47)
        self.assertEqual(sweeping_controller._target_value, 47)
        sweeping_controller.set.assert_called_with(0, 47)

    def test_set_sweep(self):
        sweeping_controller = SweepingInterpolationControlSource()
        sweeping_controller.set.reset_mock()
        sweeping_controller.set_sweep(509, 100, 1)
        self.assertEqual(sweeping_controller.set.call_count, 0)
        sweeping_controller.set_sweep(509, 100, 0.5)
        self.assertEqual(sweeping_controller.set.call_count, 3)
        sweeping_controller.set.assert_any_call(509, 1)
        sweeping_controller.set.assert_any_call(609, 0.5)
        sweeping_controller.set.reset_mock()
        sweeping_controller.set_sweep(909, 100, 1)
        self.assertEqual(sweeping_controller.set.call_count, 3)
        sweeping_controller.set.assert_any_call(909, 0.5)
        sweeping_controller.set.assert_any_call(1009, 1)
        sweeping_controller.set.reset_mock()
        sweeping_controller.set_sweep(959, 100, 0)
        self.assertEqual(sweeping_controller.set.call_count, 2)
        sweeping_controller.set.assert_any_call(1059, 0)

    def test_set_sweep_delta(self):
        with patch('pyamp.player.SweepingInterpolationControlSource.'
                   'set_sweep') as mock_set_sweep:
            sweeping_controller = SweepingInterpolationControlSource()
            sweeping_controller.set_sweep_delta(1400, 100, -0.75)
            mock_set_sweep.assert_called_with(1400, 100, 0.25)

    def test__set(self):
        sweeping_controller = SweepingInterpolationControlSource(
            scaling_factor=0.1, min_=15, max_=60)
        sweeping_controller._set(10, 66)
        def checks():
            self.assertEqual(
                len(sweeping_controller._additional_control_point_times), 1)
            self.assertEqual(
                sweeping_controller._additional_control_point_times[-1], 10)
            self.assertEqual(sweeping_controller._last_set_time, 10)
        checks()
        sweeping_controller.set.assert_called_with(10, 6)
        sweeping_controller.set.return_value = False
        sweeping_controller._set(19, 14)
        sweeping_controller.set.assert_called_with(19, 1.5)
        checks()

    def test_reset(self):
        sweeping_controller = SweepingInterpolationControlSource()
        sweeping_controller._set(10, 66)
        sweeping_controller._set(19, 14)
        self.assertEqual(
            len(sweeping_controller._additional_control_point_times), 2)
        sweeping_controller.reset()
        self.assertEqual(
            len(sweeping_controller._additional_control_point_times), 0)
        self.assertEqual(sweeping_controller.unset.call_count, 2)

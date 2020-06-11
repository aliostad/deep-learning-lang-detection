import unittest

from nilsson.start_examples.state.model.controller import TurnstileController


class TestTurnstileController(unittest.TestCase):

    def test_is_coin_false_by_default(self):
        controller = TurnstileController()

        result = controller.is_coin

        self.assertFalse(result)

    def test_is_coin_true_by_controller_coin(self):
        controller = TurnstileController()

        controller.coin()

        result = controller.is_coin
        self.assertTrue(result)

    def test_is_turn_true_by_controller_turn(self):
        controller = TurnstileController()

        controller.turn()

        result = controller.is_turn
        self.assertTrue(result)

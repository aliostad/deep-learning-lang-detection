from unittest import TestCase

from src.hockey.action import Action
from src.hockey.action_results import ActionResults
from src.hockey.controller import Controller

BOB = 'Bob'
MALORY = 'Malory'


class ControllerTest(TestCase):
    def setUp(self):
        self.initialize_controller(11, 11)

    def initialize_controller(self, x, y):
        self.controller = Controller(x, y)
        self.controller.register(BOB)
        self.controller.register(MALORY)

    def testIllegalMove(self):
        self.controller.move(Action.SOUTH)
        result = self.controller.move(Action.NORTH)
        self.assertEqual(ActionResults(MALORY, terminated=True), result)

    def testOutOfGameEast(self):
        self.controller.move(Action.EAST)
        self.controller.move(Action.EAST)
        self.controller.move(Action.EAST)
        self.controller.move(Action.EAST)
        self.controller.move(Action.EAST)
        result = self.controller.move(Action.EAST)
        self.assertEqual(ActionResults(BOB, terminated=True), result)

    def testOutOfGameWest(self):
        self.controller.move(Action.WEST)
        self.controller.move(Action.WEST)
        self.controller.move(Action.WEST)
        self.controller.move(Action.WEST)
        self.controller.move(Action.WEST)
        self.controller.move(Action.NORTH_EAST)
        self.controller.debug = True
        self.controller.move(Action.WEST)
        result = self.controller.move(Action.WEST)
        self.assertEqual(ActionResults(MALORY, terminated=True), result)

    def testLostInCorner(self):
        self.controller.move(Action.NORTH_WEST)
        self.controller.move(Action.NORTH_WEST)
        self.controller.move(Action.NORTH_WEST)
        self.controller.move(Action.NORTH_WEST)
        result = self.controller.move(Action.NORTH_WEST)
        self.assertEqual(ActionResults(MALORY, terminated=True, winner=MALORY), result)

    def testZigZag(self):
        self.initialize_controller(11, 15)
        self.controller.move(Action.WEST)
        self.controller.move(Action.NORTH_EAST)
        self.controller.move(Action.WEST)
        self.controller.move(Action.NORTH_EAST)
        self.controller.move(Action.WEST)
        self.controller.move(Action.NORTH_EAST)
        self.controller.move(Action.WEST)
        self.controller.move(Action.NORTH_EAST)
        self.controller.move(Action.WEST)
        self.controller.move(Action.NORTH_EAST)
        self.controller.move(Action.WEST)
        self.controller.move(Action.NORTH_EAST)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        result = self.controller.move(Action.SOUTH)
        self.assertEqual(ActionResults(MALORY, terminated=False), result)

    def testMaloryTheActivePlayerLose(self):
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        result = self.controller.move(Action.NORTH)
        self.assertEqual(ActionResults(BOB, terminated=True, winner=BOB), result)

    def testMaloryTheActivePlayerLoseNW(self):
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        result = self.controller.move(Action.NORTH_WEST)
        self.assertEqual(ActionResults(BOB, terminated=True, winner=BOB), result)

    def testMaloryTheInactivePlayerLoseNE(self):
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        self.controller.move(Action.NORTH)
        result = self.controller.move(Action.NORTH_EAST)
        self.assertEqual(ActionResults(BOB, terminated=True, winner=BOB), result)

    def testMaloryWin(self):
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH_WEST)
        result = self.controller.move(Action.SOUTH_EAST)
        self.assertEqual(ActionResults(MALORY, terminated=True, winner=MALORY), result)

    def testBobLoseByHimself(self):
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH)
        self.controller.move(Action.SOUTH_WEST)
        result = self.controller.move(Action.SOUTH_EAST)
        self.assertEqual(ActionResults(MALORY, terminated=True, winner=MALORY), result)

__author__ = 'victor'

import unittest
from test.store.controller.ClientControllerTestCase import ClientControllerTestCase
from test.store.controller.MovieControllerTestCase import MovieControllerTestCase
from test.store.controller.RentReturnControllerTestCase import RentReturnControllerTestCase
from test.store.controller.StatsControllerTestCase import StatsControllerTestCase


def suite():
  suites = unittest.TestSuite()
  suites.addTests(unittest.TestLoader().loadTestsFromTestCase(ClientControllerTestCase))
  suites.addTests(unittest.TestLoader().loadTestsFromTestCase(MovieControllerTestCase))
  suites.addTests(unittest.TestLoader().loadTestsFromTestCase(RentReturnControllerTestCase))
  suites.addTests(unittest.TestLoader().loadTestsFromTestCase(StatsControllerTestCase))
  return suites
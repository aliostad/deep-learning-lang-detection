import unittest
from halonctl.util import async_dispatch

def f(n=3, m=2):
	return n*m

class TestDispatchAsync(unittest.TestCase):
	def test_full_dispatches(self):
		query = { '3*2': (f, [3], {'m': 2}), '2*4': (f, [2], {'m': 4}) }
		expected = { '3*2': 6, '2*4': 8 }
		self.assertEqual(async_dispatch(query), expected)
	
	def test_no_kwargs(self):
		query = { '3*2': (f, [3]), '2*2': (f, [2]) }
		expected = { '3*2': 6, '2*2': 4 }
		self.assertEqual(async_dispatch(query), expected)
	
	def tests_no_args(self):
		query = { '3*2': (f,) }
		expected = { '3*2': 6 }
		self.assertEqual(async_dispatch(query), expected)

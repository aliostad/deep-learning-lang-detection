__author__ = 'funhead'

import unittest
from data.NeoData.SourceRepository import SourceRepository


class SourceRepositoryTest(unittest.TestCase):

    def test_GetAllSources(self):
        repository = SourceRepository()
        sources = repository.GetAllSources()
        self.assertEqual(True, len(sources) > 0)

    def test_GetSource(self):
        repository = SourceRepository()
        source = repository.GetSource(3)
        self.assertEqual(3, source.id)

    def test_GetItems(self):
        repository = SourceRepository()
        sources = repository.GetItems()
        self.assertEqual(True, len(sources) > 0)
        self.assertEqual(True, isinstance(sources[0], dict))

    def test_GetItem(self):
        repository = SourceRepository()
        source = repository.GetItem(3)
        self.assertEqual(3, source["id"])

if __name__ == '__main__':
    unittest.main()

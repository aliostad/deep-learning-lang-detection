__author__ = 'funhead'

import unittest
from data.NeoData.NeoRepository import NeoRepository


class NeoRepositoryTest(unittest.TestCase):
    def test_GetNextId(self):
        repository = NeoRepository(1, "SOURCE", "sources")
        nextId = repository.GetNextId()
        print(nextId)
        self.assertTrue(nextId > 0)
        self.assertIsInstance(nextId, int)

    def test_GetByTitle(self):
        repository = NeoRepository(1, "SOURCE", "sources")
        node = repository.GetEntityFromTitle("inde")
        self.assertIsNotNone(node)

    def test_CreateNew(self):
        repository = NeoRepository(1, "SOURCE", "sources")
        newSource = {"id": -1, "title": 'Independent', "readership": 3207, "pagerate": 20}
        newNeoSource = repository.CreateEntity(newSource)
        self.assertEqual(newNeoSource["title"], "Independent")

    def test_Update(self):
        repository = NeoRepository(1, "SOURCE", "sources")
        entity = repository.GetEntity("1")
        oldReadership = entity["readership"]
        newReadership = int(oldReadership) * 2
        entity["readership"] = newReadership
        newNeoSource = repository.UpdateEntity(entity)
        self.assertEqual(newNeoSource["readership"], newReadership)

    def test_Delete(self):
        repository = NeoRepository(1, "SOURCE", "sources")
        entity = repository.GetEntityFromTitle("inde")
        success = repository.DeleteEntity(entity["id"])
        self.assertTrue(success)


if __name__ == '__main__':
    unittest.main()

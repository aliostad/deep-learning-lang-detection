#!/usr/bin/env python

import unittest
import mis

from mis.repository import MemRepository,FileRepository

class RepositoryTest(unittest.TestCase):
    
    def setUp(self):
        self.repository = MemRepository()
        self.repository.addXML("debian-1.xml")
        self.repository.addXML("debian-1.1.xml")

    def testListManifests(self):
        manifests = self.repository.getManifests()
        self.assertEquals(["debian"], manifests)

    def testGetVersions(self):
        versions = self.repository.getVersions("debian")
        self.assertEquals(['1','1.1'], versions)

    def testFileRepository(self):
        repository = FileRepository('tmp/repository')
        self.assertEquals(['debian', 'testdir'], repository.getManifests())
        self.assertEquals(['1','2','2.1.a', '4'], repository.getVersions('debian'))
        orig_manifest = mis.manifest.serializer.fromXML('tmp/repository/testdir.xml')
        self.assertEquals(orig_manifest, repository.getManifest('testdir'))


if __name__ == "__main__":
    unittest.main()

import shutil
import tempfile
from gitexd.tests import  GitTestHelper
from gitexd.tests.git import Repository

class RepositoryTestCase(GitTestHelper):
  def testInvalidRepository(self):
    self.assertFalse(self.repository.isValidGitRepository())

  def testInitializeRepository(self):
    self.repository.initialize()

    self.assertTrue(self.repository.isValidGitRepository())

  def testAddRemoteRepository(self):
    self.repository.initialize()
    self.repository.addRemote("testSSH", "ssh://example.com/test.git")
    self.repository.addRemote("testHTTP", "http://example.com/test.git")

    output = self.repository.executeCommand("remote", ["-v"])

    self.assertTrue(output.find("ssh://example.com/test.git"))
    self.assertTrue(output.find("http://example.com/test.git"))

  def testAdvancedCommit(self):
    self.repository.initialize()
    self.generateComplicatedCommit()

    output = self.repository.executeCommand("status")

    self.assertTrue("master" not in output)
    self.assertTrue("nothing to commit" in output)

  def testCloneRepository(self):
    self.repository.initialize()
    self.generateComplicatedCommit()

    path = tempfile.mkdtemp()
    clonedRepository = Repository(path)

    clonedRepository.clone(self.path)

    shutil.rmtree(path)

  def testEqual(self):
    self.repository.initialize()
    self.generateComplicatedCommit()

    path = tempfile.mkdtemp()
    clonedRepository = Repository(path)

    clonedRepository.clone(self.path)

    self.assertEqual(self.repository, clonedRepository)

    shutil.rmtree(path)



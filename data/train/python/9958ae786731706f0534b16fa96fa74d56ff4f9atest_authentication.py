import os
import tempfile
from twisted.internet import reactor
from twisted.trial import unittest
from drupalorg.tests import _createDrupalAuthConfigFile
from drupalorg.tests.plugins import authentication
from drupalorg.tests.plugins.authentication.auth import DrupalTestAuth
from gitexd import Factory
from gitexd.interfaces import  IAuth
from gitexd.tests import ApplicationTest, formatRemote
from gitexd.tests.test_repositoryEncapsulation import GitTestHelper

class AuthenticationTests(ApplicationTest):
  pluginPackages = {
    IAuth: authentication
  }

  def _generateRepositoryDirectory(self, name=None, dir=None):
    if name is None:
      return tempfile.mkdtemp('.git', 'tmp', dir)
    else:
      if dir is not None:
        path = dir + "/" + name + ".git"
      else:
        path = "/tmp/" + name + ".git"

      os.mkdir(path)

      return path

  def _testHTTP(self, user=None, name=None):
    self.repository.initialize()

    remoteRepository = self.createTemporaryRepository(name, self.repository.path, True)

    self.repository.addRemote("origin", formatRemote("http", self.http, remoteRepository.path.split('/')[-1], user))
    self.generateComplicatedCommit()

    return remoteRepository

  def _testSSH(self, user, name=None):
    self.repository.initialize()

    remoteRepository = self.createTemporaryRepository(name, self.repository.path, True)

    self.repository.addRemote("origin", formatRemote("ssh", self.ssh, remoteRepository.path.split('/')[-1], user))
    self.generateComplicatedCommit()

    return remoteRepository

  def _setUp(self, allowAnon=False):
    self.config = _createDrupalAuthConfigFile(self.repoPath, allowAnon)

    self.app = Factory(self.config, self.pluginPackages)

    self.ssh = reactor.listenTCP(0, self.app.createSSHFactory())
    self.http = reactor.listenTCP(0, self.app.createHTTPFactory())

  def testInitialization(self):
    self._setUp()

    self.app._invariant()


  def tearDown(self):
    if self.ssh is not None:
      self.ssh.stopListening()

    if self.http is not None:
      self.http.stopListening()

    GitTestHelper.tearDown(self)


class AnonymousAuthenticationTests(AuthenticationTests):
  def testAllowed(self):
    self._setUp(True)

    remoteRepository = self._testHTTP()

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository).addCallback(processEnded)

  def testDisallowed(self):
    self._setUp(False)

    remoteRepository = self._testHTTP()

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository).addCallback(processEnded)


class PasswordAuthenticationTests(AuthenticationTests):
  def testInitialization(self):
    self._setUp()
    self.app._invariant()

    self.assertTrue(isinstance(self.app.getAuth(), DrupalTestAuth))

  def testHTTPValidUserPass(self):
    self._setUp()

    remoteRepository = self._testHTTP("test")

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "pass").addCallback(processEnded)

  def testHTTPValidUserInvalidPass(self):
    self._setUp()

    remoteRepository = self._testHTTP("test")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "invalid").addCallback(processEnded)

  def testHTTPInvalidUserPass(self):
    self._setUp()

    remoteRepository = self._testHTTP("invalid")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "pass").addCallback(processEnded)

  def testSSHValidUserPass(self):
    self._setUp()

    remoteRepository = self._testSSH("test")

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "pass").addCallback(processEnded)

  def testSSHValidUserInvalidPass(self):
    self._setUp()

    remoteRepository = self._testSSH("test")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "invalid").addCallback(processEnded)

  def testSSHInvalidUserPass(self):
    self._setUp()

    remoteRepository = self._testSSH("invalid")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "pass").addCallback(processEnded)


class KeyAuthenticationTests(AuthenticationTests):
  pluginPackages = {
    IAuth: authentication
  }

  def testInitialization(self):
    self._setUp()
    self.app._invariant()

    self.assertTrue(isinstance(self.app.getAuth(), DrupalTestAuth))

  def testDefaultUserValidKey(self):
    self._setUp()

    remoteRepository = self._testSSH("git")

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, keyFile="test").addCallback(processEnded)

  def testDefaultUserInvalidKey(self):
    self._setUp()

    remoteRepository = self._testSSH("git")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, keyFile="invalid").addCallback(processEnded)

  def testValidUserKey(self):
    self._setUp()

    remoteRepository = self._testSSH("test")

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, keyFile="test").addCallback(processEnded)

  def testValidUserInvalidKey(self):
    self._setUp()

    remoteRepository = self._testSSH("test")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, keyFile="invalid").addCallback(processEnded)

  def testInvalidUserKey(self):
    self._setUp()

    remoteRepository = self._testSSH("invalid")

    def processEnded(result):
      self.permissionDenied
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, keyFile="invalid").addCallback(processEnded)

if __name__ == '__main__':
  unittest.main()

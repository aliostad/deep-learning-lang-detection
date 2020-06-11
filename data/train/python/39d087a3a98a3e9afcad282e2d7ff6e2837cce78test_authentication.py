from gitexd.interfaces import IAuth
from gitexd.tests import ApplicationTest, formatRemote, AuthenticationTest
from gitexd.tests.plugins import keyAuth, passAuth

__author__ = 'christophe'

class KeyAuthenticationTests(AuthenticationTest):
  def setUp(self):
    ApplicationTest.setUp(self)

    self.startApplication(pluginPackages={
      IAuth: keyAuth
    })

  def testAnonymous(self):
    remoteRepository = self._testPush(None)

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository).addCallback(processEnded)

  def testInvalidUser(self):
    remoteRepository = self._testPush("random")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository).addCallback(processEnded)

  def testValidUser(self):
    remoteRepository = self._testPush("key")

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, keyFile = "test").addCallback(processEnded)

class PasswordAuthenticationTests(AuthenticationTest):
  def setUp(self):
    ApplicationTest.setUp(self)

    self.startApplication(pluginPackages={
      IAuth: passAuth
    })

  def _testSSH(self, user):
    self.repository.initialize()

    remoteRepository = self.createTemporaryRepository(None, self.repository.path, True)

    self.repository.addRemote("origin", formatRemote("ssh", self.ssh, remoteRepository.path.split('/')[-1], user))
    self.generateComplicatedCommit()

    return remoteRepository

  def _testHTTP(self, user):
    self.repository.initialize()

    remoteRepository = self.createTemporaryRepository(None, self.repository.path, True)

    self.repository.addRemote("origin", formatRemote("http", self.http, remoteRepository.path.split('/')[-1], user))
    self.generateComplicatedCommit()

    return remoteRepository

  def testSSHInvalidUser(self):
    remoteRepository = self._testSSH("random")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository).addCallback(processEnded)

  def testHTTPInvalidUser(self):
    remoteRepository = self._testHTTP("random")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository).addCallback(processEnded)

  def testSSHValidUserWrongPassword(self):
    remoteRepository = self._testSSH("pass")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "test").addCallback(processEnded)

  def testHTTPValidUserWrongPassword(self):
    remoteRepository = self._testHTTP("pass")

    def processEnded(result):
      self.assertPermissionDenied()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "test").addCallback(processEnded)

  def testSSHValidUser(self):
    remoteRepository = self._testSSH("pass")

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "test_pass").addCallback(processEnded)

  def testHTTPValidUser(self):
    remoteRepository = self._testHTTP("pass")

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "test_pass").addCallback(processEnded)
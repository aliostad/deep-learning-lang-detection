from gitexd.interfaces import IAuth
from gitexd.tests import formatRemote, AuthenticationTest
from gitexd.tests.plugins import default, repoAuthorization, refsAuthorization
from gitexd.tests.test_workflow import ApplicationTest

class RepositoryAuthorizationTests(AuthenticationTest):
  def setUp(self):
    ApplicationTest.setUp(self)

    self.startApplication(pluginPackages={
      IAuth: repoAuthorization
    })

  def testSSHPush(self):
    remoteRepository = self._testPush(None)

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, keyFile = "test").addCallback(processEnded)

  def testSSHPull(self):
    remoteRepository = self._testPull(None)

    def processEnded(result):
      self.assertError("Only PUSH requests are supported.")
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pullRepository(self.repository, keyFile = "test").addCallback(processEnded)

  def testHTTPPush(self):
    remoteRepository = self._testPush(None, True)

    def processEnded(result):
      # Push requests through HTTP are first noticed as PULLs
      self.assertError("Only PUSH requests are supported.")
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository).addCallback(processEnded)

  def testHTTPPull(self):
    remoteRepository = self._testPull(None, True)

    def processEnded(result):
      self.assertError("Only PUSH requests are supported.")
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pullRepository(self.repository).addCallback(processEnded)


class PerLabelAuthorizationTests(ApplicationTest):
  def setUp(self):
    ApplicationTest.setUp(self)

    self.startApplication(pluginPackages={
      IAuth: refsAuthorization
    })

  def testSSHUnauthorizedPush(self):
    self.repository.initialize()

    remoteRepository = self.createTemporaryRepository(None, self.repository.path, True)

    self.repository.addRemote("origin", formatRemote("ssh", self.ssh, remoteRepository.path.split('/')[-1]))
    self.generateComplicatedCommit()

    def processEnded(result):
      self.assertNotSuccess()
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository, "derp", keyFile = "test").addCallback(processEnded)

  def testHTTPUnauthorizedPush(self):
    self.repository.initialize()

    remoteRepository = self.createTemporaryRepository(None, self.repository.path, True)

    self.repository.addRemote("origin", formatRemote("http", self.http, remoteRepository.path.split('/')[-1]))
    self.generateComplicatedCommit()

    def processEnded(result):
      self.assertError("You are not allowed to PUSH to second-branch.")
      self.assertNotEqual(self.repository, remoteRepository)

    return self.pushRepository(self.repository).addCallback(processEnded)

  def testSSHAuthorizedPull(self):
    self.repository.initialize()

    otherRepository = self.createTemporaryRepository(None, self.repository.path, False)

    self.repository.addRemote("origin", formatRemote("ssh", self.ssh, otherRepository.path.split('/')[-1]))
    self.generateComplicatedCommit(otherRepository)

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, otherRepository)

    self.assertNotEqual(self.repository, otherRepository)

    return self.pullRepository(self.repository, keyFile = "test").addCallback(processEnded)

  def testHTTPAuthorizedPull(self):
    self.repository.initialize()

    otherRepository = self.createTemporaryRepository(None, self.repository.path, False)

    self.repository.addRemote("origin", formatRemote("http", self.http, otherRepository.path.split('/')[-1]) + "/.git")
    self.generateComplicatedCommit(otherRepository)

    def processEnded(result):
      self.assertNoError()
      self.assertEqual(self.repository, otherRepository)

    self.assertNotEqual(self.repository, otherRepository)

    return self.pullRepository(self.repository).addCallback(processEnded)
import shutil
import tempfile
from twisted.internet import reactor
from twisted.trial import unittest
from drupalorg import plugins
from gitexd import Factory
from gitexd.interfaces import IRepositoryRouter
from gitexd.tests import GitTestHelper
from gitexd.tests.test_plugins import _createDefaultConfigFile

__author__ = 'christophe'

class RepositoryRouterTests(GitTestHelper):
  def setUp(self):
    GitTestHelper.setUp(self)

    self.config = _createDefaultConfigFile(self.repoPath)

    pluginPackages = {
      IRepositoryRouter: plugins
    }

    self.app = Factory(self.config, pluginPackages)

    self.ssh = reactor.listenTCP(0, self.app.createSSHFactory())
    self.http = reactor.listenTCP(0, self.app.createHTTPFactory())

  def testInitialization(self):
    self.app._invariant()

  def testDefaultScheme(self):
    remoteRepository = self.createTemporaryRepository()
    path = self.app.getRepositoryRouter().route(self.app, ["DEFAULT", remoteRepository.path.split("/")[-1]])

    self.assertEqual(path, remoteRepository.path)

  def testCustomScheme(self):
    projectPath = tempfile.mkdtemp()

    self.app.getConfig().add_section("project")
    self.app.getConfig().set("project", "repositoryPath", projectPath)

    remoteRepository = self.createTemporaryRepository(path=projectPath)
    path = self.app.getRepositoryRouter().route(self.app, ["project", remoteRepository.path.split("/")[-1]])

    self.assertEqual(path, remoteRepository.path)

    shutil.rmtree(projectPath)

  def testMultipleCustomScheme(self):
    projectPath = tempfile.mkdtemp()
    sandboxPath = tempfile.mkdtemp()

    self.app.getConfig().add_section("project")
    self.app.getConfig().set("project", "repositoryPath", projectPath)

    self.app.getConfig().add_section("sandbox")
    self.app.getConfig().set("sandbox", "repositoryPath", sandboxPath)

    remoteProjectRepository = self.createTemporaryRepository(path=projectPath)
    path = self.app.getRepositoryRouter().route(self.app, ["project", remoteProjectRepository.path.split("/")[-1]])

    self.assertEqual(path, remoteProjectRepository.path)

    remoteSandboxRepository = self.createTemporaryRepository(path=sandboxPath)
    path = self.app.getRepositoryRouter().route(self.app, ["sandbox", remoteSandboxRepository.path.split("/")[-1]])

    self.assertEqual(path, remoteSandboxRepository.path)

    shutil.rmtree(projectPath)
    shutil.rmtree(sandboxPath)

  def testUnknownScheme(self):
    """This should default to the standard repository path."""

    remoteRepository = self.createTemporaryRepository()
    path = self.app.getRepositoryRouter().route(self.app, ["project", remoteRepository.path.split("/")[-1]])

    self.assertEqual(path, remoteRepository.path)

  def testUnknownRepository(self):
    path = self.app.getRepositoryRouter().route(self.app, ["DEFAULT", "drupal"])

    self.assertEqual(path, None)

  def tearDown(self):
    self.ssh.stopListening()
    self.http.stopListening()

    GitTestHelper.tearDown(self)

if __name__ == '__main__':
  unittest.main()

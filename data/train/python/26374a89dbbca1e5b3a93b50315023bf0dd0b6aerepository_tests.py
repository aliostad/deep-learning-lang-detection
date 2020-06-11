import nose
from nose.tools import *
from unittest import TestCase

from shutil import rmtree
from tempfile import mkdtemp

from repo.repository_factory import RepositoryFactory
from repo.mercurial_repository import MercurialRepository
from repo.git_repository import GitRepository

class RepositoryTests(TestCase):
    def test_get_mercurial_repo_from_factory_for_directory_with_hg_repo(self):
        directory = mkdtemp('-caboose-rep-works-test')
        MercurialRepository(directory, init=True)
        repo = RepositoryFactory.get_repository(directory)
        eq_(MercurialRepository, type(repo))
        rmtree(directory)
    
    def test_get_git_repo_from_factory_for_directory_with_git_repo(self):
        directory = mkdtemp('-caboose-rep-works-test')
        GitRepository(directory, init=True)
        repo = RepositoryFactory.get_repository(directory)
        eq_(GitRepository, type(repo))
        rmtree(directory)

    @raises(Exception)
    def test_repository_factory_throws_for_directory_without_repo(self):
        directory = mkdtemp('-caboose-rep-fails-correctly-test')
        try:
            repo = RepositoryFactory.get_repository(directory)
        finally:
            rmtree(directory)


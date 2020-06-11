import modulespecific
import unittest

class TestRepository(modulespecific.ModuleSpecificTestCase):
    """Test the Repository interface."""        
    def setUp(self):
        """Create and connect to a repository."""
        self.basic_repo = self.test_module.BasicRepository()
        self.repo = self.basic_repo.repo()
        
    def tearDown(self):
        """Destroy the created repository."""
        self.basic_repo.teardown()

class TestRepositoryRevisions(TestRepository):
    """Test Repository.revisions"""
    def runTest(self):
        """Test that the 'basic' test repository reports 4 revisions."""
        self.assertTrue(self.repo)
        revisions = self.repo.revisions
        self.assertEquals(len(revisions), 4)

class TestRepositoryBranches(TestRepository):
    """Test Repository.branches"""
    def runTest(self):
        """Test that the 'basic' test repository reports 1 branch."""
        branches = self.repo.branches
        self.assertEquals(len(branches), 1)
        
class TestRepositoryURI(TestRepository):
    """Test Repository.uri"""
    def runTest(self):
        """Test that repositories respond to the uri method."""
        uri = self.repo.uri
        # No throw exception
        
class TestRepositoryCreate(modulespecific.ModuleSpecificTestCase):
    """Test repository creation."""
    def runTest(self):
        """Defer testing to the individual test module."""
        self.test_module.test_create(testinstance=self)
        
    
        
'''
Created on 2011/05/07

@author: miio
'''
from django.conf import settings
from libwaz.test.repository import SvnTestRepository
import unittest
import pysvn
import os

class SvnTestRepositoryTest(unittest.TestCase):
    def setUp(self):
        settings.PROJECTS_REPOSITORY_DIRECTORY = settings.PROJECTS_REPOSITORY_DIRECTORY_UNIT
        master_name                            = "unit_1_master"
        co_name                                = "1"
        self.client                            = pysvn.Client()
        self.repository                        = SvnTestRepository()
        self.repository.set_repository_base_path(settings.PROJECTS_REPOSITORY_DIRECTORY)
        self.repository_master_path            = self.repository.create_master(master_name)
        self.repository_path                   = self.repository.create_checkout(master_name,co_name)
        
    def tearDown(self):
        self.repository.delete()
        
    def test_exist_repository_master_directory(self):
        self.assertTrue(os.path.isdir(self.repository_master_path))
    
    def test_exist_repository_directory(self):
        self.assertTrue(os.path.isdir(self.repository_path))
        
    def test_dummy_files_commit_get_commit_log(self):
        commit_message = 'Add dummy files'
        file_path      = os.path.join(self.repository_path,"dummy.hoge.txt")
        self.repository.touch_and_commit_file(file_path,commit_message)
        self.assertEquals(commit_message , self.client.log(self.repository_path)[0].message)
        
    def test_delete_all_repository_and_repository_master(self):
        self.repository.delete()
        self.assertFalse(os.path.isdir(self.repository_master_path))
        self.assertFalse(os.path.isdir(self.repository_path))
        
if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()     
import unittest
import os
from evolve.database_repository import DatabaseRepository
from evolve.database_repository import RepositoryAlreadyExists
from sqlalchemy import *
from migrate import *


class TestDatabaseRepository(unittest.TestCase):
    def setUp(self):
        self.dbstring = 'sqlite:///test.db'
        
    def tearDown(self):
        if os.path.exists('test.db'):
            os.remove('test.db')
            
    def setup_table(self, dbstring, table_name):
        engine = create_engine(dbstring)
        metadata = MetaData()
        metadata.bind = engine
        table = Table(table_name, metadata)
        return table
            
    def assertTableExists(self, dbstring, table_name):
        table = self.setup_table(dbstring, table_name)
        self.assertTrue(table.exists())
        
    def assertTableDoesNotExist(self, dbstring, table_name):
        table = self.setup_table(dbstring, table_name)
        self.assertFalse(table.exists())
        
    def test_initialize_database(self):
        """The table _evolve should be created"""
        dbstring = self.dbstring
        repository = DatabaseRepository(dbstring)
        repository.initialize()
        self.assertTableExists(dbstring, '_evolve')
        
    def test_already_initialized_database_failure(self):
        """raise RepositoryAlreadyExists"""
        dbstring = self.dbstring
        repository = DatabaseRepository(dbstring)
        repository.initialize()
        self.assertRaises(RepositoryAlreadyExists, 
            getattr(repository, 'initialize'))
            
    def test_deploy_create(self):
        """Create a table based on a JSON schema"""
        dbstring = self.dbstring
        repository = DatabaseRepository(dbstring)
        repository.initialize()
        change = {
            "change":"create",
            "schema":{
                "id":"test",
                "type":"object",
                "properties":{
                    "text_column":{"type":"string"}
                }
            }
        }
        repository.deploy(change)
        self.assertTableExists(dbstring, "test")
        
        
if __name__ == '__main__':
    unittest.main()
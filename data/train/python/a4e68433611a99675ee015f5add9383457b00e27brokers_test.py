#!python
import unittest
from mock import Mock, MagicMock
from brokers import SommelierBroker

# Simple tests to make sure that the brokers call the db how we want them to, i.e.
# using and templating their queries as we expect

class BrokersTest(unittest.TestCase):

    def setUp(self):
        # instantiate broker for testing
        self.sommelier_broker = SommelierBroker()
        # create mock DB
        db = MagicMock()
        db.execute = MagicMock()
        db.fetch_all = MagicMock()
        db.fetch_one = MagicMock()
        # inject mock db into broker
        self.sommelier_broker.db = db
 
    def test_get_authors(self):
        authors = self.sommelier_broker.get_authors()
        expected_query = self.sommelier_broker.authors_query
        self.sommelier_broker.db.execute.asset_called_once_with(expected_query)
        self.sommelier_broker.db.fetch_all.assert_called_once()
    
    def test_get_wines(self):
        authors = self.sommelier_broker.get_wines()
        expected_query = self.sommelier_broker.wines_query
        self.sommelier_broker.db.execute.asset_called_once_with(expected_query)
        self.sommelier_broker.db.fetch_all.assert_called_once()
    
    def test_get_wine_page(self):
        page = self.sommelier_broker.get_wine_page(1)
        expected_query = self.sommelier_broker.wine_page_query.format(50, 0)
        self.sommelier_broker.db.execute.assert_called_once_with(expected_query)
        self.sommelier_broker.db.fetch_all.assert_called_once_with()
    
    def test_get_wine_num_pages(self):
        numpages = self.sommelier_broker.get_num_wine_pages()
        expected_query = self.sommelier_broker.wine_count_query
        self.sommelier_broker.db.execute.assert_called_once_with(expected_query)
        self.sommelier_broker.db.fetch_one.assert_called_once_with()
    
    def test_get_wine(self):
        wine = self.sommelier_broker.get_wine(123)
        expected_query = self.sommelier_broker.wine_query.format(123)
        self.sommelier_broker.db.execute.assert_called_once_with(expected_query)
        self.sommelier_broker.db.fetch_one.assert_called_once_with()
    
    def test_get_author_ids(self):
        ids = self.sommelier_broker.get_author_ids()
        expected_query = self.sommelier_broker.author_ids_query
        self.sommelier_broker.db.execute.assert_called_once_with(expected_query)
        self.sommelier_broker.db.fetch_all.assert_called_once_with()

    def test_get_author_page(self):
        page = self.sommelier_broker.get_author_page(1)
        expected_query = self.sommelier_broker.author_page_query.format(50, 0)
        self.sommelier_broker.db.execute.assert_called_once_with(expected_query)
        self.sommelier_broker.db.fetch_all.assert_called_once_with()
    
    def test_get_author_num_pages(self):
        numpages = self.sommelier_broker.get_num_author_pages()
        expected_query = self.sommelier_broker.author_count_query
        self.sommelier_broker.db.execute.assert_called_once_with(expected_query)
        self.sommelier_broker.db.fetch_one.assert_called_once_with()
    
    def test_get_author(self):
        author = self.sommelier_broker.get_author(123)
        expected_query = self.sommelier_broker.author_query.format(123)
        self.sommelier_broker.db.execute.assert_called_once_with(expected_query)
        self.sommelier_broker.db.fetch_one.assert_called_once_with()

if __name__ == '__main__':
    unittest.main()


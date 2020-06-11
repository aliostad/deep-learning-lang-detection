import unittest
import test
from unittest.mock import Mock
from applications.editArticle.controllers import save_article_data


class SaveArticleComponents(unittest.TestCase, test.CustomAssertions):

    def setUp(self):
        self.saveData = save_article_data.SaveData(dependencies=test.mocks)
        self.saveData.clientModel.form = {
            'FieldStorage': {},
            'id': 1,
        }
        self.saveData.setUp()

    def test_instance_of_SaveData(self):
        self.assertIsInstance(self.saveData, save_article_data.SaveData)

    def test_artticles_property(self):
        """Should have the .articles property."""
        self.assertHasAttr(self.saveData, 'articles')

    def test_model_property(self):
        self.assertHasAttr(self.saveData, 'model')

    def test_id_property(self):
        self.assertHasAttr(self.saveData, 'id')

    def test_date_property(self):
        self.assertHasAttr(self.saveData, 'date')


if __name__ == '__main__':
    unittest.main()
import test
import unittest
from unittest.mock import Mock
from applications.editArticle.controllers import save_image


class Object(object): pass


class SaveCoverImageTest(unittest.TestCase, test.CustomAssertions):
    """Test all behavior related with te cover image.
    """
    def setUp(self):
        os = Mock()
        os.remove = Mock()
        self.saveImage = save_image.SaveImage(dependencies=test.mocks)
        self.saveImage.warnings = False
        self.saveImage.clientModel.form = {
            'cover': True
            ,'ext': 'png'
            ,'cover_image': 'ñalsjdfñlaksdjf'
            ,'id': 1}
        self.saveImage.get_article = Mock(return_value={
            'directory': ':memory:/prueba-1'
            ,'article_name': 'prueba-1'})

    def test_SaveImage_instance(self):
        """Should be an SaveImage instance."""
        self.assertIsInstance(self.saveImage, save_image.SaveImage)

    @unittest.skip('For now the cover image is out to use.')
    def test_get_article_model(self):
        """Should get the article model."""
        self.saveImage.setUp(Mock())
        self.assertCalled(self.saveImage.get_article)

    @unittest.skip('I need find a way to test the random uuid in the name.')
    def test_cover_file_path(self):
        """Should create the path of the cover image file."""
        self.saveImage.setUp()
        self.saveImage.multimedia.get = Mock(return_value=[''])
        expected = ':memory:/prueba-1/prueba-1-cover.png'
        obtained = self.saveImage.create_file_name()
        self.assertEqual(obtained, expected)

    @unittest.skip('Not implemented yet.')
    def test_should_create_all_files_paths(self):
        self.saveImage.setUp()
        expected = [
            ':memory:/prueba-1/prueba-1-cover.png'
            ,':memory:/prueba-1/prueba-1-cover.png'
            ,':memory:/prueba-1/prueba-1-cover.png'
            ,':memory:/prueba-1/prueba-1-cover.png'
            ,':memory:/prueba-1/prueba-1-cover.png'
            ,':memory:/prueba-1/prueba-1-cover.png'
        ]

    @unittest.skip('For now the cover image is out to use.')
    def test_get_buffer_cover_image(self):
        """The get_buffer_image method should
        return the raw image of the cover.
        """
        obtained = self.saveImage.get_buffer_image(self.saveImage.clientModel.form)
        expected = 'ñalsjdfñlaksdjf'
        self.assertEqual(obtained, expected)

    @unittest.skip('For now the cover image is out to use.')
    def test_erase_the_old_cover_image(self):
        """Should remove the old cover image file."""
        self.saveImage.setUp(Mock())
        self.saveImage.multimedia.get = Mock(
            return_value=[':memory:/prueba-1/prueba-1-cover.png'])
        self.saveImage.save_file()
        self.saveImage.remove.assert_called_with(
            ':memory:/prueba-1/prueba-1-cover.png')


class SaveImageTest(unittest.TestCase, test.CustomAssertions):
    """Test all behavior of the multimedia associated to an article.
    """
    def setUp(self):
        self.saveImage = save_image.SaveImage(dependencies=test.mocks)
        self.saveImage.warnings = False
        FieldStorage = Object()
        FieldStorage.filename = 'an_file_name.jpg'
        self.saveImage.clientModel.form = {
            'cover': False
            ,'ext': 'png'
            ,'input_image_c15': 'ñalsjdfñlaksdjf'
            ,'id': 1
            ,'cid': 'c15'
            ,'FieldStorage': {
                'input_image_c15': FieldStorage
                }
            ,'id_article': 1
            }
        self.saveImage.get_article = Mock(return_value={
            'directory': ':memory:/prueba-1'
            ,'article_name': 'prueba-1'})

    def test_SaveImage_instance(self):
        """Should be an SaveImage instance."""
        self.assertIsInstance(self.saveImage, save_image.SaveImage)

    def test_get_article_model(self):
        """Should ."""
        self.saveImage.setUp()
        self.assertCalled(self.saveImage.get_article)

    @unittest.skip('no way to test this')
    def test_cover_file_path(self):
        """Should create the path of the cover image file."""
        self.saveImage.setUp()
        self.saveImage.multimedia.get = Mock(return_value=[14])
        expected = ':memory:/prueba-1/prueba-1-14.png'
        obtained = self.saveImage.create_file_name()
        self.assertEqual(obtained, expected)

    def test_get_buffer_single_image(self):
        """The get_buffer_image method should
        return the raw image of the single image.
        """
        obtained = self.saveImage.get_buffer_image(self.saveImage.clientModel.form)
        expected = 'ñalsjdfñlaksdjf'
        self.assertEqual(obtained, expected)

    def test_erase_the_old_image(self):
        """Should remove the old image file."""
        self.saveImage.setUp(Mock())
        self.saveImage.multimedia.get = Mock(
            return_value=[':memory:/prueba-1/prueba-1-14.png'])
        self.saveImage.save_file()
        self.saveImage.remove.assert_called_with(
            ':memory:/prueba-1/prueba-1-14.png')


if __name__ == '__main__':
    unittest.main()
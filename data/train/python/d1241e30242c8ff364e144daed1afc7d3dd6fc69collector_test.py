__author__ = 'Ahmed Gamal A. Ali'
import errno
import os

from tests.utils import remove_save_dir


import unittest
from src.image_collector import CollectImages


class ImagesCollectorTest(unittest.TestCase):

    def test_image_file_not_exists(self):
        image_file = '/path/not/found/file.txt'
        save_dir = '/some/save/dir'
        try:
            CollectImages(image_file=image_file, save_dir=save_dir)
        except OSError, e:
            self.assertEqual(e.message, "File %s Not Found" % image_file)
        except Exception, e:
            self.fail('Unexpected exception thrown: %s' % e)
        else:
            self.fail('Expected Exception not thrown')
        remove_save_dir(save_dir)

    def test_image_save_dir_not_exists(self):
        image_file = './tests/fixtures/empty.txt'
        save_dir = '/some/save/dir'
        try:
            CollectImages(image_file=image_file, save_dir=save_dir)
        except OSError, e:
            self.assertIn("Save Directory not found", e.message)
        except Exception, e:
            self.fail('Unexpected exception thrown: %s' % e)
        else:
            self.fail('Expected Exception not thrown')
        remove_save_dir(save_dir)

    def test_image_save_dir_permission_denied(self):
        image_file = './tests/fixtures/empty.txt'
        save_dir = '/dir'
        try:
            CollectImages(image_file=image_file, save_dir=save_dir, create=True)
        except OSError, e:
            self.assertEqual(e.errno, errno.EACCES)
        except Exception, e:
            self.fail('Unexpected exception thrown: %s' % e)
        else:
            self.fail('Expected Exception not thrown')
        remove_save_dir(save_dir)

    def test_image_empty_file(self):
        image_file = './tests/fixtures/empty.txt'
        save_dir = '/tmp/save_dir/'
        try:
            CollectImages(image_file=image_file, save_dir=save_dir, create=True)
        except Exception, e:
            self.assertEqual('Images File is Empty', e.message)
        else:
            self.fail('Expected Exception not thrown')
        remove_save_dir(save_dir)

    def test_no_urls_in_file(self):
        image_file = './tests/fixtures/invalid.txt'
        save_dir = '/tmp/save_dir/'
        try:
            CollectImages(image_file=image_file, save_dir=save_dir, create=True)
        except Exception, e:
            self.assertEqual('No Valid URLs Found', e.message)
        else:
            self.fail('Expected Exception not thrown')
        remove_save_dir(save_dir)

    def test_one_urls_in_file(self):
        image_file = './tests/fixtures/one_url.txt'
        save_dir = '/tmp/save_dir/'
        try:
            CollectImages(image_file=image_file, save_dir=save_dir, create=True)
        except Exception, e:
            self.fail('Not Expected Exception thrown: ' + str(e))
        self.assertEqual(1, len(os.listdir(os.path.join(save_dir, 'images'))))
        remove_save_dir(save_dir)

    def test_valid_but_not_found_urls(self):
        image_file = './tests/fixtures/valid_not_found.txt'
        save_dir = '/tmp/save_dir/'
        try:
            CollectImages(image_file=image_file, save_dir=save_dir, create=True)
        except Exception, e:
            self.fail('Not Expected Exception thrown: ' + str(e))
        self.assertEqual(0, len(os.listdir(os.path.join(save_dir, 'images'))))
        remove_save_dir(save_dir)

    def test_mixed_file(self):
        image_file = './tests/fixtures/mixed.txt'
        save_dir = '/tmp/save_dir/'
        try:
            CollectImages(image_file=image_file, save_dir=save_dir, create=True)
        except Exception, e:
            self.fail('Not Expected Exception thrown: ' + str(e))
        self.assertEqual(3, len(os.listdir(os.path.join(save_dir, 'images'))))
        remove_save_dir(save_dir)

    def test_repeated_urls(self):
        image_file = './tests/fixtures/repeated.txt'
        save_dir = '/tmp/save_dir/'
        try:
            CollectImages(image_file=image_file, save_dir=save_dir, create=True)
        except Exception, e:
            self.fail('Not Expected Exception thrown: ' + str(e))
        self.assertEqual(3, len(os.listdir(os.path.join(save_dir, 'images'))))
        remove_save_dir(save_dir)

    def test_all_valid(self):
        image_file = './tests/fixtures/all_valid.txt'
        save_dir = '/tmp/save_dir/'
        try:
            CollectImages(image_file=image_file, save_dir=save_dir, create=True)
        except Exception, e:
            self.fail('Not Expected Exception thrown: ' + str(e))
        self.assertEqual(4, len(os.listdir(os.path.join(save_dir, 'images'))))
        remove_save_dir(save_dir)
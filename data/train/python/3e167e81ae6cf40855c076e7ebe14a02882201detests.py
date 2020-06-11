from os.path import join
import json
import unittest
import tempfile
import shutil

from main import Repository

class TestRepository(unittest.TestCase):

    def setUp(self):
        self.root = tempfile.mkdtemp()
        self.repository = Repository(self.root)

    def tearDown(self):
        shutil.rmtree(self.root)

    def test_should_get_vcs_dir(self):
        self.assertEqual(
            self.repository.get_vcs_dir(),
            join(self.root, '.myvcs')
        )

    def test_should_get_log_path(self):
        self.assertEqual(
            self.repository.get_log_path(),
            join(self.root, '.myvcs', '.log.json')
        )

    def test_should_write_log(self):
        # Given
        data = {
            '1': {
                'timestamp': 123412.12,
                'message': 'Dummy commit'
            }
        }

        # When
        self.repository.write_log(data)

        # Then
        with open(self.repository.get_log_path()) as f:
            saved_data = json.load(f)
        self.assertDictEqual(data, saved_data)

    def test_should_read_log(self):
        # Given
        data = {
            '1': {
                'timestamp': 123412.12,
                'message': 'Dummy commit'
            }
        }
        self.repository.write_log(data)

        # When
        saved_data = self.repository.read_log()

        # Then
        self.assertDictEqual(data, saved_data)

    def test_should_get_versions(self):
        # Given
        data = {
            '1': {
                'timestamp': 123412.12,
                'message': 'Dummy commit'
            },
            '2': {
                'timestamp': 1234123.12,
                'message': 'Dummy commit'
            }

        }
        self.repository.write_log(data)
        repository = Repository(self.root)

        # When
        versions = repository.versions

        # Then
        self.assertEqual(2, versions)

    def test_should_commit(self):
        # Given
        repository = self.repository
        message = 'This is my first commit!'

        # When
        repository.commit(message)

        # Then
        data = repository.read_log()
        self.assertEqual(1, repository.versions)
        self.assertEqual(1, len(data))



if __name__ == '__main__':
    unittest.main()

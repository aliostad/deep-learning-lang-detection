import unittest
import mock
from click.testing import CliRunner
import msword_cli
import os
from .util import MockApp

@mock.patch('msword_cli.WORD', spec_set=MockApp(['foo.docx']))
class TestSaveCommand(unittest.TestCase):
    def setUp(self):
        self.runner = CliRunner()

    def test_save_defaults(self, mock_app):
        ''' Test save defaults. '''
        result = self.runner.invoke(msword_cli.save)
        self.assertEqual(result.exit_code, 0)
        mock_app.ActiveDocument.Save.assert_called_with(NoPrompt=False)

    def test_save_path(self, mock_app):
        ''' Test save to path. '''
        filename = 'bar.docx'
        result = self.runner.invoke(msword_cli.save, ['--path', filename])
        self.assertEqual(result.exit_code, 0)
        mock_app.ActiveDocument.SaveAs.assert_called_with(os.path.abspath(filename))

    def test_force_save(self, mock_app):
        ''' Test force save. '''
        result = self.runner.invoke(msword_cli.save, ['--force'])
        self.assertEqual(result.exit_code, 0)
        mock_app.ActiveDocument.Save.assert_called_with(NoPrompt=True)

    def test_save_all(self, mock_app):
        ''' Test save all. '''
        result = self.runner.invoke(msword_cli.save, ['--all'])
        self.assertEqual(result.exit_code, 0)
        mock_app.Documents.Save.assert_called_with(NoPrompt=False)

    def test_force_save_all(self, mock_app):
        ''' Test force save all. '''
        result = self.runner.invoke(msword_cli.save, ['--all', '--force'])
        self.assertEqual(result.exit_code, 0)
        mock_app.Documents.Save.assert_called_with(NoPrompt=True)
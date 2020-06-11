import inspect
import unittest

from af.controller.data.CSVController import CSVController
from af.controller.data.DataFactory import DataFactory
from af.controller.data.SqliteController import SqliteController


class TestDataFactory(unittest.TestCase):

    def test_create_controller_ok(self):
        mock_location = 'location'
        controller_sql = DataFactory.create_controller(mock_location, SqliteController.CONTROLLER_TYPE)
        self.assertTrue(isinstance(controller_sql, SqliteController), "The controller created is not an instance of SqliteController")

        controller_csv = DataFactory.create_controller(mock_location, CSVController.CONTROLLER_TYPE)
        self.assertTrue(isinstance(controller_csv, CSVController), "The controller created is not an instance of CSVController")

    def test_create_invalid_controller_fails(self):
        mock_location = 'location'
        inexistent_controller_type = 'INEXISTENT'
        failed_creation = False

        try:
            DataFactory.create_controller(mock_location, inexistent_controller_type)
        except ValueError:
            failed_creation = True

        self.assertTrue(failed_creation, "The method should have failed creating an unexistent controller")

    def test_all_available_controllers_are_gathered_ok(self):
        available_controllers = DataFactory.get_available_controllers()
        print available_controllers
        self.assertTrue(len(available_controllers) == 2, "There should be only 2 data controllers")
        self.assertTrue(SqliteController.CONTROLLER_TYPE in available_controllers, "SqliteController not found on available controllers")
        self.assertTrue(CSVController.CONTROLLER_TYPE in available_controllers, "CSVController not found on available controllers")

    def test_get_controller_file_extension_ok(self):
        sql_expected_extension = SqliteController.CONTROLLER_EXTENSION
        csv_expected_extension = CSVController.CONTROLLER_EXTENSION

        sql_extension = DataFactory.get_controller_file_extension(SqliteController.CONTROLLER_TYPE)
        csv_extension = DataFactory.get_controller_file_extension(CSVController.CONTROLLER_TYPE)

        self.assertEqual(sql_expected_extension, sql_extension, "The extensions do not match")
        self.assertEqual(csv_expected_extension, csv_extension, "The extensions do not match")

    def test_fail_getting_inexistent_controller_extension(self):
        failed = False

        try:
            DataFactory.get_controller_file_extension('INEXISTENT')
        except ValueError:
            failed = True

        self.assertTrue(failed, "The method should have failed creating an unexistent controller")

    def test_get_controller_from_extension_ok(self):
        extension = SqliteController.CONTROLLER_EXTENSION

        controller = DataFactory.get_controller_from_extension(extension)

        self.assertTrue(inspect.isclass(controller), "The controller retrieved is not the expected one")
        self.assertTrue(isinstance(controller('.'), SqliteController), "The controller retrieved is not the expected one")

    def test_fail_get_controller_from_extension(self):
        failed = False

        try:
            DataFactory.get_controller_from_extension('INEXISTENT')
        except ValueError:
            failed = True

        self.assertTrue(failed, "The method should have failed looking for an unexistent controller with that extension")
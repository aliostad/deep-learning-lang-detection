import unittest
import sqlite3

from create_company import data_base
from manage_company import manage_company


class TestManageCompany(unittest.TestCase):

    def setUp(self):
        self.company_database = data_base()
        self.company_database.create_db()
        self.manage_company = manage_company()

    def tearDown(self):
        connection = sqlite3.connect('mydb')
        cursor = connection.cursor()

        cursor.execute("DROP TABLE users")
        connection.commit()
        connection.close()

    def test_monthly_spending(self):
        self.assertEqual(26500, self.manage_company.monthly_spending())

    def test_yearly_spending(self):
        self.assertEqual(147500, self.manage_company.yearly_spending())

    def test_add_employee(self):
        pass

    def test_delete_employee(self):
        pass

    def test_update_employee(self):
        pass

if __name__ == '__main__':
    unittest.main()

from nose.tools import istest
from unittest import TestCase

from refactoring.refactoring.extractclass import UserRepository


class UserRepositoryTest(TestCase):
    def populate_database(self, repository):
        repository.insert_users([
            {
                'name': 'Nat Pryce',
                'active': True,
            },
            {
                'name': 'Steve Freeman',
                'active': True,
            },
            {
                'name': 'Alfred Hitchcock',
                'active': False,
            },
        ])

    @istest
    def finds_currently_active_users(self):
        repository = UserRepository()
        self.populate_database(repository)

        users = repository.find_active_users()

        users_names = sorted([user.name for user in users])
        self.assertEqual(users_names, ['Nat Pryce', 'Steve Freeman'])

    @istest
    def finds_only_active_users(self):
        repository = UserRepository()
        self.populate_database(repository)

        users = repository.find_active_users()

        self.assertTrue(all(user.active for user in users))

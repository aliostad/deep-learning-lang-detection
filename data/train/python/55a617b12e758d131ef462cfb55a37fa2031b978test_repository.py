# coding=utf-8
from django.test import TestCase
from django_sae.db.repository import RepositoryBase
from tests.models import User


class UserRepository(RepositoryBase):
    Model = User


class RepositoryTest(TestCase):
    def setUp(self):
        self.r = UserRepository()

    def test_create(self):
        item_id = 123
        item = dict(id=item_id)

        self.r.create(item)
        self.assertTrue(User.objects.filter(id=item_id).exists())

        self.r.delete(item)
        self.assertFalse(User.objects.filter(id=item_id).exists())


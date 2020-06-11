from unittest import TestCase

from app.entities import Item, User
from app.services.repositories.item import ItemRepository
from app.services.repositories.user import UserRepository


class TestItemRepository(TestCase):

    def test_write_one(self):
        user = User.get_mock_object()
        item = Item.get_mock_object()
        item.user_uuid = user.uuid
        UserRepository.write_one(user)
        ItemRepository.write_one(item)
        obj = ItemRepository.read_one(item.uuid)
        assert obj.uuid == item.uuid
        assert obj.user_uuid == user.uuid

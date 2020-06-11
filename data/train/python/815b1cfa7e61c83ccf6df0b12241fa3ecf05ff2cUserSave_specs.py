from django.contrib.auth.models import Group
from django.test import TestCase
from restapi.views.user.UserSave import UserSave
from mock import Mock

test_request = Mock()


class UserSaveSpecs(TestCase):
    def setUp(self):
        self.user_save = UserSave

    def test__class_methods__exists(self):
        self.assert_(hasattr(self.user_save, 'save'))

    def test__save_method__return_correct_request(self):
        # arrange
        group = Group.objects.create(name='test')
        group.save()
        self.user_group_exist = test_request
        self.user_group_exist_nonexist = test_request()

        self.user_group_exist.DATA = {'user_in_groups': ['test']}
        self.user_group_exist_nonexist.DATA = {'user_in_groups': ['another_test']}

        # act
        self.user_save.save(self.user_group_exist)
        self.user_save.save(self.user_group_exist_nonexist)

        # assert
        self.assertEqual(self.user_group_exist.DATA['groups'][0], group.pk)
        self.assertEqual(self.user_group_exist_nonexist.DATA.get('groups', False), False)

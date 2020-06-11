__author__ = 'aj'

from menu_base import *
from actions_module.user_actions.create_new_user import *
from actions_module.user_actions.edit_user import *


class MenuManageUser(MenuBase):
    def __init__(self):
        self.menu_title = "Manage User Menu"
        self.manage_user_options = {'1': 'Create new user', '2': 'Update existing user', '3': 'Delete existing user'}
        self.manage_user_actions = {'1': CreateUser, '2': EditUser}
        MenuBase.__init__(self, self.manage_user_options, self.manage_user_actions, self.menu_title)

    def execute(self):
        menu_manage_user = MenuManageUser()
        menu_manage_user.display_menu()

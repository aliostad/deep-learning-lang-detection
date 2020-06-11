__author__ = 'Alex Alvarez'

from menu_base import *
from actions_module.director_actions.create_new_director import *
from actions_module.director_actions.edit_director import *
from actions_module.director_actions.list_directors import *


class MenuManageDirector(MenuBase):
    def __init__(self):
        self.menu_title = "Manage Director Menu"
        self.manage_user_options = {'1': 'Create new director', '2': 'Update existing director',
                                    '3': 'List directors'}
        self.manage_user_actions = {'1': CreateDirector, '2': EditDirector, '3': ListDirectors}
        MenuBase.__init__(self, self.manage_user_options, self.manage_user_actions, self.menu_title)

    def execute(self):
        menu_manage_director = MenuManageDirector()
        menu_manage_director.display_menu()
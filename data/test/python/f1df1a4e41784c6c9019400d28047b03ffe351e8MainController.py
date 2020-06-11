__author__ = 'ezequiel'

from src.controllers.SalesController import SalesController
from src.controllers.OrgController import OrgController
from src.utils.Menus import Menus


class MainController:
    """
    MainController class
    MainController is the class that models the controller for the terminal-based interface.
    """
    def __init__(self, sample_data):
        """
        Init method for MainController

        :param sample_data: Dictionary with the organization's data
        :return: An instance of MainController
        """

        self.org = sample_data["organization"]
        self.commissions = sample_data["commissions"]

    def menu_redirect(self):
        """
        Redirect the user to another controller depending on the selected option
        """

        option = Menus.main_controller_menu()
        if option == 1:
            OrgController.manage_org(self, self.org, self.commissions)
        elif option == 2:
            SalesController.manage_sales(self, self.org)
        elif option == 0:
            print("\nBye!\n")

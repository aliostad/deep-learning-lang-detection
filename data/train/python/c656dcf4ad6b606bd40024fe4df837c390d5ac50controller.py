# coding=utf-8
from __future__ import unicode_literals
from stroller2.controllers.manage.category import ManageCategoryController
from tg import TGController, expose
from stroller2.controllers.manage.product import ManageProductController
from stroller2.controllers.manage.user_address import ManageUserAddressesController

class ManageController(TGController):
    product = ManageProductController()
    category = ManageCategoryController()
    address = ManageUserAddressesController()
    @expose()
    def index(self):
        return {}
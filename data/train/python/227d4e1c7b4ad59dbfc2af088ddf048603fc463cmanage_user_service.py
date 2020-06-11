from dal.manage_users_adapter import ManageUsersAdapter
from api.common_helpers.common_utils import CommonHelper


class ManageUserService:

    def __init__(self):
        pass

    @staticmethod
    def register_user(
               email=None,
               password=None,
               first_name=None,
               last_name=None,
               phone=None):
        ManageUsersAdapter.create(manage_user_guid=CommonHelper.generate_guid(),
                                  manage_user_email=email,
                                  manage_user_password=password,
                                  manage_user_first_name=first_name,
                                  manage_user_last_name=last_name,
                                  manage_user_phone=phone,
                                  is_deleted=False)

    @staticmethod
    def get_user_by_email(email=None):
        manage_user = ManageUsersAdapter.read({
            'manage_user_email': email
        })
        return manage_user

    @staticmethod
    def get_user_by_guid(guid=None):
        manage_user = ManageUsersAdapter.read({
            'manage_user_guid': guid
        })
        return manage_user

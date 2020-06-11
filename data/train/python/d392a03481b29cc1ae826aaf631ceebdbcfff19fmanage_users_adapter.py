from models.manage_users import ManageUsers
from database import db


class ManageUsersAdapter:
    def __init__(self):
        pass

    @staticmethod
    def create(manage_user_guid=None,
               manage_user_email=None,
               manage_user_password=None,
               manage_user_first_name=None,
               manage_user_last_name=None,
               manage_user_phone=None,
               is_system=False,
               is_deleted=False,
               is_active=False
               ):
        manage_user = ManageUsers(manage_user_guid=manage_user_guid,
                                  manage_user_email=manage_user_email,
                                  manage_user_password=manage_user_password,
                                  manage_user_first_name=manage_user_first_name,
                                  manage_user_last_name=manage_user_last_name,
                                  manage_user_phone=manage_user_phone,
                                  is_system=is_system,
                                  is_deleted=is_deleted,
                                  is_active=is_active)
        db.add(manage_user)
        db.commit()

    @staticmethod
    def update(query=None, new_manage_user=None):
        db.query(ManageUsers) \
            .filter_by(**query) \
            .update(new_manage_user)
        db.commit()

    @staticmethod
    def delete(query=None):
        db.query(ManageUsers). \
            filter_by(**query). \
            delete()
        db.commit()

    @staticmethod
    def read(query=None):
        users = db.query(ManageUsers) \
            .filter_by(**query).all()
        return users

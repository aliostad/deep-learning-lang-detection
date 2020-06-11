import db.user_repository
import db.user

class users:

    def __init__(self, conn):
       self.user_repository = db.user_repository.user_repository(conn)

    def create(self, email, first_name, last_name, google_user_id, facebook_user_id):
        user = db.user.user(None, email, first_name, last_name, google_user_id, facebook_user_id)
        return self.user_repository.create(user)

    def find_by_google_user_id(self, google_user_id):
        return self.user_repository.get_by_google_user_id(google_user_id)

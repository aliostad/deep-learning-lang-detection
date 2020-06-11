from givabit.backend.user_repository import UserRepository
from givabit.backend.session_repository import SessionRepository

from givabit.webapp.base_page import BasePage

class LoginPage(BasePage):
    def get(self):
        self.write_template('login', {'title': 'Givabit - Login'})

    def post(self):
        session = SessionRepository(UserRepository()).log_in(
            email=self.request.POST['email'],
            password=self.request.POST['passwd'])
        response = self.redirect('/')
        response.set_cookie('sessionid', session.id, httponly=True)
        return response

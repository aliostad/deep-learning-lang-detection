from sqlalchemy.orm import scoped_session, sessionmaker
from . import engine

Session = scoped_session(sessionmaker(bind=engine))


class SQLAlchemy(object):
    def __init__(self, controller):
        self.controller = controller
        self.controller.events.before_dispatch += self.before_dispatch
        self.controller.events.after_dispatch += self.after_dispatch

    def before_dispatch(self, controller):
        # docker run --name tardis -e MYSQL_ROOT_PASSWORD=root -d mysql:latest
        session = Session()
        setattr(controller, 'db_session', session)

    def after_dispatch(self, response, controller):
        Session.remove()

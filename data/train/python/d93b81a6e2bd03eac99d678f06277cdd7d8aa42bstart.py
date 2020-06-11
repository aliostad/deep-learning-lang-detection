from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from base import Base
from controller import *
from views import MainView

from settings import DB_CONNECTION_STRING


engine = create_engine(DB_CONNECTION_STRING)
Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()

auth_controller = AuthenticationController(session)
transaction_controller = TransactionController(session)
main_view = MainView(auth_controller, transaction_controller)

main_view.render()

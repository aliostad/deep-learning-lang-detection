import unittest
import session_broker
from FakeModel import MyModel

class TestSessionBroker(unittest.TestCase):

    def setUp(self):
        self.session_broker = session_broker.SessionBroker()
        self.session_broker.registerGame('my-game', MyModel)

    def test_should_allow_to_create_a_session(self):
        id = self.session_broker.create_session('my-game')
        self.assertIn(id, self.session_broker.sessions)

    def test_should_allow_to_remove_a_session(self):
        id = self.session_broker.create_session('my-game')
        self.session_broker.remove(id)
        self.assertNotIn(id, self.session_broker.sessions)

    def test_should_remove_a_session_if_its_not_alive_anymore(self):
        id = self.session_broker.create_session('my-game')
        session = self.session_broker.get_session(id)
        session.add_player("tata", "toto")
        self.session_broker.kill_if_dead(id)
        self.assertIn(id, self.session_broker.sessions)
        session.remove("tata")
        self.assertNotIn(id, self.session_broker.sessions)

    def test_should_create_a_session_with_a_model(self):
        id = self.session_broker.create_session('my-game')
        session = self.session_broker.get_session(id)
        self.assertIsInstance(session.model, MyModel)

    def test_should_get_a_session_by_its_id(self):
        id = self.session_broker.create_session('my-game')
        session = self.session_broker.get_session(id)

    def test_should_provide_the_list_of_session(self):
        self.session_broker.create_session('my-game')
        self.session_broker.create_session('my-game')
        sessions = self.session_broker.get_sessions()
        self.assertEqual(len(sessions.values()), 2)
        self.assertEqual(
            sessions.values()[0],
            {"players" : 0,
             "slots" : 3,
             "name" : "my model"})

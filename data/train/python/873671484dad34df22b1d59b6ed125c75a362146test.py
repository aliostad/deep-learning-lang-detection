from unittest import TestCase
from unittest.mock import MagicMock
from rsmt.application import EventService, AttendanceService
from rsmt.domain import EventRepository, UserRepository, User


class TestEventService(TestCase):
    def setUp(self):
        self.event_repository = MagicMock(EventRepository, name='event_repository')
        self.user_repository = MagicMock(UserRepository, name='user_repository')

        self.service = EventService(
            event_repository=self.event_repository,
            user_repository=self.user_repository
        )

    def test_list_events(self):
        events = self.service.list_events()

        self.assertIsNotNone(events)


class TestAttendanceService(TestCase):
    def setUp(self):
        self.event_repository = MagicMock(EventRepository,
                                          name='event_repository')
        self.user_repository = MagicMock(UserRepository, name='user_repository')
        self.user_repository.find_user_by_email.return_value = None
        self.user_repository.create_user = MagicMock(User)

        self.service = AttendanceService(
            event_repository=self.event_repository,
            user_repository=self.user_repository,
        )

    def test_attend(self):
        self.service.attend_event_by_user(user_email='john@example.com', event_id=1)
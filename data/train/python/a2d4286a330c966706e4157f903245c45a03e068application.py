from rsmt.utils import cached_property, service


class EventService:
    def __init__(self, event_repository, user_repository):
        self._event_repository = event_repository
        self._user_repository = user_repository

    def list_events(self, current_user_email=None):
        user = None
        if current_user_email:
            user = self._user_repository.find_user_by_email(current_user_email)

        return self._event_repository.list_events(current_user=user)

    @service
    def create_event(self, name, description, start, end):
        event = self._event_repository.create_event(
            name, description, start, end
        )

        return event.event_id


class AttendanceService:
    def __init__(self, event_repository, user_repository):
        self._event_repository = event_repository
        self._user_repository = user_repository

    @service
    def attend_event_by_user(self, event_id, user_email):
        event = self._event_repository.read_event(event_id)
        user = self._user_repository.find_user_by_email(user_email)

        if user is None:
            user = self._user_repository.create_user(user_email)

        user.attend(event)


class ApplicationRegistry:
    '''
        Application object.

        Contains all available services.
    '''
    def __init__(self, infrastructure):
        self._infrastructure = infrastructure

    @cached_property
    def event_service(self):
        return self._infrastructure.transactional(
            EventService(
                event_repository=self._infrastructure.event_repository,
                user_repository=self._infrastructure.user_repository
            ))

    @cached_property
    def attendance_service(self):
        return self._infrastructure.transactional(
            AttendanceService(
                event_repository=self._infrastructure.event_repository,
                user_repository=self._infrastructure.user_repository
            ))
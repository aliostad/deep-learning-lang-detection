from charitybot2.persistence.donation_sqlite_repository import DonationSQLiteRepository
from charitybot2.persistence.event_sqlite_repository import EventSQLiteRepository


class DonationsService:
    def __init__(self, repository_path):
        self._repository_path = repository_path
        self._event_repository = None
        self._donations_repository = None

    def open_connections(self):
        if self._event_repository is None:
            self._event_repository = EventSQLiteRepository(db_path=self._repository_path)
        if self._donations_repository is None:
            self._donations_repository = DonationSQLiteRepository(db_path=self._repository_path)

    def close_connections(self):
        self._event_repository.close_connection()
        self._donations_repository.close_connection()

    def get_all_donations(self, event_identifier):
        return self._donations_repository.get_event_donations(event_identifier=event_identifier)

    def get_latest_donation(self, event_identifier):
        return self._donations_repository.get_latest_event_donation(event_identifier=event_identifier)

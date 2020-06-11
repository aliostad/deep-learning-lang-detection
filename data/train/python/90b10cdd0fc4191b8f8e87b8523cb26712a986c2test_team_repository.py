from django.test import TestCase
from board_tests.contracts.test_team_repository_contract import TestTeamRepositoryContractCreateTeam, TestTeamRepositoryContractFetchTeam, \
    TestTeamRepositoryContractFetchTeamList
from whiteboard_web.repositories.team_repository import TeamRepository


class CreateTeamTestCase(TestCase, TestTeamRepositoryContractCreateTeam):
    def setUp(self):
        self.subject = TeamRepository()


class FetchTeamTestCase(TestCase, TestTeamRepositoryContractFetchTeam):
    def setUp(self):
        self.subject = TeamRepository()


class TestFetchTeamList(TestCase, TestTeamRepositoryContractFetchTeamList):
    def setUp(self):
        self.subject = TeamRepository()
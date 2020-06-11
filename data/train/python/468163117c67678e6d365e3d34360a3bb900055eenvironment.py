from board_tests.test_support.doubles.fake_help_repository import FakeHelpRepository
from board_tests.test_support.doubles.fake_new_face_repository import FakeNewFaceRepository
from board_tests.test_support.doubles.fake_team_repository import FakeTeamRepository
from board_tests.test_support.doubles.gui_spy import GuiSpy


def before_scenario(context, scenario):
    context.gui = GuiSpy()
    context.team_repository = FakeTeamRepository()
    context.new_face_repository = FakeNewFaceRepository()
    context.help_repository = FakeHelpRepository()

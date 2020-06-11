from board import present_team_list
from django.views.generic import View
from whiteboard_web.observers.present_team_list_observer import PresentTeamListObserver
from whiteboard_web.repositories.team_repository import TeamRepository


class PresentTeamListView(View):

    @staticmethod
    def get(request):
        observer = PresentTeamListObserver()
        team_repository = TeamRepository()
        command = present_team_list(team_repository=team_repository,
                                    observer=observer)
        command.execute()

        return observer.response()
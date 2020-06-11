from board import present_team
from django.views.generic import View
from whiteboard_web.observers.present_team_observer import PresentTeamObserver
from whiteboard_web.repositories.new_face_repository import NewFaceRepository
from whiteboard_web.repositories.team_repository import TeamRepository


class PresentTeamDetailView(View):
    @staticmethod
    def get(request, team_identifier):
        team_identifier = int(team_identifier)
        observer = PresentTeamObserver()
        team_repository = TeamRepository()
        new_face_repository = NewFaceRepository()
        command = present_team(team_identifier=team_identifier,
                               team_repository=team_repository,
                               new_face_repository=new_face_repository,
                               observer=observer)
        command.execute()

        return observer.response()
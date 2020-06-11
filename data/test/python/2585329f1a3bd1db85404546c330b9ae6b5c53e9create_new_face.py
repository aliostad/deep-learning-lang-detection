from board import create_new_face
from django.core.context_processors import csrf
from django.template.response import SimpleTemplateResponse
from django.views.generic import View
from whiteboard_web.observers.create_new_face_observer import CreateNewFaceObserver
from whiteboard_web.repositories.new_face_repository import NewFaceRepository
from whiteboard_web.repositories.team_repository import TeamRepository


class CreateNewFaceView(View):

    @staticmethod
    def get(request, team_identifier):
        context = {}
        context.update(csrf(request))
        return SimpleTemplateResponse(template='whiteboard_web/new_face_form.html', context=context)

    @staticmethod
    def post(request, team_identifier):
        name = request.POST['name']
        team_identifier = int(team_identifier)
        observer = CreateNewFaceObserver(request)
        team_repository = TeamRepository()
        new_face_repository = NewFaceRepository()
        command = create_new_face(name=name,
                                  new_face_repository=new_face_repository,
                                  team_identifier=team_identifier,
                                  team_repository=team_repository,
                                  observer=observer)
        command.execute()

        return observer.response()

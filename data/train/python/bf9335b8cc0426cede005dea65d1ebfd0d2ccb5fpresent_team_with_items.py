

class PresentTeamWithItems(object):
    def __init__(self,
                 team_identifier,
                 team_repository,
                 new_face_repository,
                 help_repository,
                 observer):
        self.team_identifier = team_identifier
        self.team_repository = team_repository
        self.new_face_repository = new_face_repository
        self.help_repository = help_repository
        self.observer = observer

    def execute(self):
        team_identifier = self.team_identifier
        team = self.team_repository.fetch_team(team_identifier)
        new_faces = self.new_face_repository.fetch_new_faces(team_identifier)
        helps = self.help_repository.fetch_helps(team_identifier)
        self.observer.did_present_team_with_items(team, new_faces, helps)

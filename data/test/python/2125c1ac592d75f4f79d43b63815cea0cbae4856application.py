from flask import Flask, request
import json
from app.repository_factory import RepositoryFactory
from app.team_member import TeamMember

yuca_wall = Flask(__name__)

@yuca_wall.route('/api/team_members', methods=['POST'])
def new_team_member():
    repository = RepositoryFactory.create_repository()
    data = json.loads(request.data)
    team_member = TeamMember(data['name'])
    repository.insert(team_member)
    data['late_days'] = 0
    return json.dumps(data), 201

@yuca_wall.route('/api/team_members', methods=['GET'])
def all_team_members():
    repository = RepositoryFactory.create_repository()
    team_members = [{'name': team_member.name, 'late_days': team_member.late_days}
                    for team_member in repository.get_members()]

    return json.dumps(team_members), 200


if __name__ == '__main__':
    yuca_wall.run()

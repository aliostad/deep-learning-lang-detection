from flask import Flask, request, abort, jsonify
from flask.ext.restful import Resource, Api
from flask.ext.restful.utils import cors
from flask_mail import Mail
from model import db, bcrypt, redis_store
from api.userAPI import UserAPI, LoginAPI, FBUserAPI, FBLoginAPI, ActivateAPI
from api.profileAPI import ProfileAPI, ProfileIconAPI, FindProfileAPI, ViewProfileAPI
from api.lol_teamAPI import LolTeamAPI, MylolTeamAPI, ManagelolTeamAPI, LolTeamIconAPI, SearchlolTeamAPI, ViewlolTeamAPI, InviteTeamRequestAPI, JoinTeamRequestAPI
from api.friendsAPI import FriendsListAPI, FriendsRequestAPI
from api.passwordAPI import ChangePasswordAPI, ForgetPasswordAPI
from api.tournamentAPI import CreateTournamentAPI, JoinTournamentAPI, TournamentResultAPI, ViewTournamentAPI
from api.reportAPI import LolReportAPI
from api.postAPI import PlayerPostAPI, TeamPostAPI
from api.challongeAPI import ChallongeAPI,ChallongeJoinAPI,ChallongeResultAPI
from util.exception import InvalidUsage

app = Flask(__name__)
app.config.from_object('config') 

db.init_app(app)
bcrypt.init_app(app)
redis_store.init_app(app)
mail = Mail(app)

api = Api(app)
api.decorators = [cors.crossdomain(origin='*',
                                   headers='my-header, accept, content-type, token')]

api.add_resource(UserAPI, '/create_user')
api.add_resource(LoginAPI, '/login')
api.add_resource(FBUserAPI, '/fb_create_user')
api.add_resource(FBLoginAPI, '/fb_login')
api.add_resource(ActivateAPI, '/activate_account')

api.add_resource(ChangePasswordAPI, '/change_password')
api.add_resource(ForgetPasswordAPI, '/forget_password')

api.add_resource(ProfileAPI, '/profile')
api.add_resource(ProfileIconAPI, '/upload_profile_icon')
api.add_resource(FindProfileAPI, '/search_profile')
api.add_resource(ViewProfileAPI, '/view_profile/<int:profileID>')

api.add_resource(FriendsListAPI, '/friends_list')
api.add_resource(FriendsRequestAPI, '/friends_request')

api.add_resource(LolTeamAPI, '/create_team/lol')
api.add_resource(MylolTeamAPI, '/my_team/lol')
api.add_resource(ManagelolTeamAPI, '/manage_team/lol')
api.add_resource(LolTeamIconAPI, '/upload_team_icon/lol')
api.add_resource(SearchlolTeamAPI, '/search_team/lol')
api.add_resource(ViewlolTeamAPI, '/view_team/lol/<int:teamID>')
api.add_resource(InviteTeamRequestAPI, '/invite_request/lol')
api.add_resource(JoinTeamRequestAPI, '/join_request/lol')

api.add_resource(CreateTournamentAPI, '/create_tournament')
api.add_resource(JoinTournamentAPI, '/join_tournament')
api.add_resource(TournamentResultAPI, '/report_result')
api.add_resource(ViewTournamentAPI, '/view_tournament')

api.add_resource(PlayerPostAPI, '/player_post')
api.add_resource(TeamPostAPI, '/team_post')

api.add_resource(LolReportAPI, '/match_report/lol')

api.add_resource(ChallongeAPI, '/challonge')
api.add_resource(ChallongeJoinAPI, '/challonge_join')
api.add_resource(ChallongeResultAPI, '/challonge_result')

@app.errorhandler(InvalidUsage)
def handle_invalid_usage(error):
	response = jsonify(error.to_dict())
	response.status_code = error.status_code
	return response

if __name__ == '__main__':
	app.run(debug=True,host='0.0.0.0')




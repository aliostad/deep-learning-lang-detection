from django.conf.urls import url
from .decorators import staff_member_required

from manager.views import *

urlpatterns = [
    url(r'^manage_teams/delete/(?P<pk>\d+)/$', staff_member_required(TeamDelete), name="delete_team"),
    url(r'^manage_teams/$', 'manager.views.teamManager', name='team_manager'),
    url(r'^manage_tournaments/(?P<pk>\d+)/status/(?P<status>[1-4]+)/$', 'manager.views.tournament_setstatus', name='set_status'),
    url(r'^manage_tournaments/divs/(?P<pk>\d+)/status/(?P<status>[1-3]+)/$', 'manager.views.tournament_setstatus', name='set_group_status'),
    url(r'^manage_tournaments/delete/(?P<pk>\d+)/$', TournamentDelete, name='delete_tournament'),
    url(r'^manage_tournaments/$', tournamentManager, name='tournament_manager'),
    url(r'^manage_tournaments/edit/(?P<id>\d+)/$', 'manager.views.tournamentManager', name='edit_tournament'),
    url(r'^manage_tournaments/divs/(?P<pk>\d+)/$', 'manager.views.tournamentDivGroupManager', name='divgroup_tournament'),
    url(r'^assign_group/(?P<team_pk>\d+)/(?P<tournament_pk>\d+)/(?P<division_pk>\d+)/(?P<group_pk>\d+)/$', 'manager.views.add_team_to_div_group', name="add_team_to_group"),
    url(r'^assign_group/(?P<team_pk>\d+)/(?P<tournament_pk>\d+)/(?P<division_pk>\d+)/$', 'manager.views.add_team_to_div_group', name="add_team_to_div"),
    url(r'^manage_tournaments/group/drop_teams/(?P<pk>\d+)/(?P<team_pk>\d+)/$', 'manager.views.group_team_dropper', name="drop_team_from_group"),
    url(r'^manage_tournaments/group/drop_teams/(?P<pk>\d+)/$', 'manager.views.group_team_dropper', name="drop_all_teams_from_group"),
    url(r'^manage_tournaments/division/(?P<division_pk>\d+)/group/(?P<group_pk>\d+)/start_round/$', 'manager.views.start_round', name='start_round_group'),
    url(r'^manage_tournaments/division/(?P<division_pk>\d+)/start_round$', 'manager.views.start_round', name='start_round_div'),
    url(r'^manage_matches/$', 'manager.views.matchManager', name='match_manager'),
    url(r'^manage_matches/edit/(?P<id>\d+)/$', 'manager.views.matchManager', name='edit_match'),
    url(r'^manage_matches/is_setup/(?P<id>\d+)/$', 'manager.views.match_setup_complete', name='setup_match'),
    url(r'^manage_servers/$', 'manager.views.serverManager', name='server_manager'),
    url(r'^manage_servers/edit/(?P<id>\d+)/$', 'manager.views.serverManager', name='edit_server'),
    url(r'^manage_servers/delete/(?P<id>\d+)/$', 'manager.views.serverdelete', name='delete_server'),
]

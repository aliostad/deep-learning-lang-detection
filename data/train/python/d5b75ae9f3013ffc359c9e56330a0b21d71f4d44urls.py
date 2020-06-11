from django.conf.urls import patterns, include, url
from django.contrib import admin
from game.views import *
from django.contrib.auth.decorators import login_required
from django.views.generic import TemplateView


urlpatterns = patterns('',
    url( r'^$', CreateGame.as_view(), name='create_game' ),
    url( r'^(?P<game_id>[\d]+)/start$', Start.as_view(), name='start' ),
    url( r'^(?P<game_id>[\d]+)/manage$', Manage.as_view(), name='manage' ),
    url( r'^(?P<game_id>[\d]+)/manage/add$', Manage_add.as_view(), name='manage_add' ),
    url( r'^(?P<game_id>[\d]+)/manage/remove$', Manage_remove.as_view(), name='manage_remove' ),
    url( r'^(?P<game_id>[\d]+)/round$', RoundView.as_view(), name='round' ),
    url(r'^leaderboard$', Leaderboard.as_view(), name='leaderboard' ),
    url(r'^(?P<game_id>[\d]+)/round/stats$', StatsView.as_view(), name='stats' ),
    url(r'^find$', UnfinishedGames.as_view(), name='unfinished' ),
    url(r'^(?P<game_id>[\d]+)/endgame$', EndGame.as_view(), name='endgame' ),
)

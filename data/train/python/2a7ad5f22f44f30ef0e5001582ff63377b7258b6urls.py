import controller
from django.conf.urls import patterns, url
#from django.views.generic import ListView
#import models


urlpatterns = patterns('',
        url(r'^$', controller.index),
        url(r'^player_registration', controller.player_registration),
        url(r'^team_registration', controller.team_registration),
        url(r'^list_players', controller.list_players),
        url(r'^list_teams', controller.list_teams),
#        url(r'^tournaments/$', ListView.as_view(model=models.Tournament)),
        url(r'^singlematches/$', controller.singlematches),
        url(r'^doublesmatches/$', controller.doublesmatches),
        url(r'^tournaments/$', controller.tournaments),
        url(r'^tournaments/(?P<tournament_id>\d+)/$', controller.tournaments),
        url(r'^list/(?P<match_type>\w)/matches$', controller.list_matches),
        url(r'^set/(?P<match_type>\w)/(?P<match_no>\d+)/score$', controller.set_match_score),
        url(r'^thanks', controller.thanks),
)

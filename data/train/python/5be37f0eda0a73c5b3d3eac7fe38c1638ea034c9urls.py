from django.conf.urls import patterns, include, url
from bets import views

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'worldcupbet.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r'^$', views.index, name='index'),
    url(r'^(?P<game_id>\d+)/$', views.bet, name='detail'),
    url(r'^(?P<game_id>\d+)/save$', views.save_bet, {'mode': 'old'}, name='save_bet'),
    url(r'^(?P<game_id>\d+)/save-live$', views.save_bet, {'mode': 'live'}, name='save_bet'),
    url(r'^game-score/(?P<game_id>\d+)/save$', views.save_game_score, name='save_game_score'),
    url(r'^game-score/(?P<game_id>\d+)/$', views.game_score, name='game_score'),
    url(r'^overall', views.overall, name='overall'),
    url(r'^rules', views.rules, name='rules')
)

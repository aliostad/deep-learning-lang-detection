from django.conf.urls import patterns, url

from wwmafia import api, views

urlpatterns = patterns('',
    url(r'^$', views.index, name = 'index'),
    url(r'^api/user/new/',      api.new_user, name = 'new user'),
    url(r'^api/user/login/',    api.login, name = 'login'),
    url(r'^api/user/',          api.user_info, name = 'list user info'),
    url(r'^api/game/new/',      api.new_game, name = 'new game'),
    url(r'^api/game/join/',     api.join_game, name = 'join game'),
    url(r'^api/game/rules/',    api.rules, name= 'game rules'),
    url(r'^api/game/start/',    api.start_game, name = 'start game'),
    url(r'^api/game/leave/',    api.leave_game, name = 'leave game'),
    url(r'^api/game/list/',     api.list_games, name= 'list games/players'),
    url(r'^api/game/',          api.game_info, name = 'game info'),  
    url(r'^api/role/wolves/',   api.list_wolves, name = 'list wolves'),
    url(r'^api/role/kill/',     api.kill, name = 'kill'),
    url(r'^api/role/vote/',     api.vote, name = 'vote'),
    url(r'^api/role/location/', api.report_position, name = 'report position'),
    url(r'^api/role/living/',   api.list_living, name = 'list living roles'),
    url(r'^api/role/dead/',     api.list_dead, name= 'list dead roles'),
    url(r'^api/role/smell/',    api.smell, name = 'smell'),
    url(r'^api/role/cycle/',    api.cycle, name = 'cycle'),
    url(r'^api/role/',          api.role_info, name = 'role info'),
)

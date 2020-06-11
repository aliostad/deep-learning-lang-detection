from django.conf import settings
from django.conf.urls import include, url
from . import views

urlpatterns = [
    url(r'^$',                              views.home, name='picker-home'),
    url(r'^roster/$',                       views.roster, name='picker-roster'),
    url(r'^roster/(?P<season>20\d\d)/$',    views.roster, name='picker-season-roster'),
    url(r'^roster/p/(\w+)/$',               views.roster_profile, name='picker-roster-profile'),
    url(r'^teams/$',                        views.teams, {'abbr': None}, name='picker-teams'),
    url(r'^teams/(?P<abbr>\w+)/$',          views.teams, name='picker-team'),
    url(r'^schedule/$',                     views.schedule, {'season': None}, name='picker-schedule'),
    url(r'^schedule/(?P<season>\d{4})$',    views.schedule, name='picker-schedule'),
    
    url(r'^results/$',                      views.results, name='picker-results'),
    url(r'^results/(\d{4})/$',              views.results_by_season, name='picker-season-results'),
    url(r'^results/(\d{4})/(-?\d+)/$',      views.results_by_week, name='picker-game-sequence'),
    url(r'^results/(\d{4})/playoffs/$',     views.results_for_playoffs, name='picker-playoffs-results'),
    
    url(r'^picks/$',                        views.picks, name='picker-picks'),
    url(r'^picks/(\d{4})/$',                views.picks_by_season, name='picker-season-picks'),
    url(r'^picks/(\d{4})/(-?\d+)/$',        views.picks_by_week, name='picker-picks-sequence'),
    url(r'^picks/(\d{4})/playoffs/$',       views.picks_for_playoffs, name='picker-playoffs-picks'),
    url(r'^picks/history/$',                views.picks_history),
    
    url(r'^manage/$',                       views.management_home, name='picker-manage'),
    url(r'^manage/game/(\d+)/$',            views.manage_game, name='picker-manage-game'),
    url(r'^manage/(\d{4})/$',               views.manage_season),
    url(r'^manage/(\d{4})/(-?\d+)/$',       views.manage_week, name='picker-manage-week'),
    url(r'^manage/(\d{4})/(playoffs)/$',    views.manage_playoffs, name='picker-manage-week'),
    url(r'^manage/playoff-builder/$',       views.manage_playoff_builder, name='picker-manage-playoff-builder'),
]

if settings.DEBUG:
    from django.views.static import serve
    urlpatterns += [url(
        r'^media/(?P<path>.*)$', 
        serve, 
        {'document_root': settings.MEDIA_ROOT, 'show_indexes': True}
    )]

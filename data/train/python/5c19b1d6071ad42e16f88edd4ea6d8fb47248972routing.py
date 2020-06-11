"""Routes configuration

The more specific and detailed routes should be defined first so they
may take precedent over the more generic routes. For more information
refer to the routes manual at http://routes.groovie.org/docs/
"""
from routes import Mapper

def make_map(config):
    """Create, configure and return the routes Mapper"""
    map = Mapper(directory=config['pylons.paths']['controllers'],
                 always_scan=config['debug'])
    map.minimization = False
    map.explicit = False

    # The ErrorController route (handles 404/500 error pages); it should
    # likely stay at the top, ensuring it can always be resolved
    map.connect('/error/{action}', controller='error')
    map.connect('/error/{action}/{id}', controller='error')

    # CUSTOM ROUTES HERE
    map.redirect('/*(url)^(/)', '/{url}/', _redirect_code='302 Moved Temporarily')
    map.connect('/', controller='home', action='index')
    map.connect('/trade/{id}/', controller='trade', action='index')
    map.connect('/bet/{id}/', controller='bet', action='index')
    map.connect('/manage/leagues/add/', controller='manage', action='addLeague')
    map.connect('/manage/leagues/edit/{id}/', controller='manage', action='editLeague')
    map.connect('/manage/leagues/remove/{id}/', controller='manage', action='removeLeague')
    map.connect('/manage/teams/', controller='manage', action='teamsLeagues')
    map.connect('/manage/teams/{leagueID}/', controller='manage', action='teamsList')
    map.connect('/manage/teams/{leagueID}/add/', controller='manage', action='addTeam')
    map.connect('/manage/teams/{leagueID}/remove/{teamID}/', controller='manage', action='removeTeam')
    map.connect('/manage/teams/{leagueID}/edit/{teamID}/', controller='manage', action='editTeam')
    map.connect('/manage/matches/', controller='manage', action='matchesLeagues')
    
    map.connect('/{controller}/', action='index')
    map.connect('/{controller}/{action}/')
    map.connect('/{controller}/{action}/{id}')
    return map
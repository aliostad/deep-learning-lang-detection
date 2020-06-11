import cherrypy
from tools.common import render_template
from core.repositories.shows import ShowRepository
from core.repositories.episodes import EpisodeRepository

class Root:
    show_repository = ShowRepository()
    episode_repository = EpisodeRepository()
    
    def index(self):
        shows = self.show_repository.get_continuing_shows()
        wanted = self.show_repository.get_wanted_shows()
        episodes = self.episode_repository.get_latest_episodes()
        return render_template("index.html",
            shows = shows,
            wanted = wanted,
            episode_list = dict(episodes = episodes, \
                title = "Latest episodes", mode = 'latest', show_id = -1), \
            current = "home")
    
    def manage(self):
        shows = self.show_repository.get_manageable_shows()
        wanted = self.show_repository.get_wanted_shows()
        return render_template("manage.html",
            shows = shows,
            wanted = wanted,
            current = "manage")
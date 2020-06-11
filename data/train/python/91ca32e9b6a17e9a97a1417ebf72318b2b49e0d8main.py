import kivy
kivy.require("1.8.1")

from kivy.config import Config
Config.set('graphics', 'width', '450')
Config.set('graphics', 'height', '600')

from kivy.app import App
from panda.api import API
from mousiki.gui.player import Player


class Mousiki(App):
    def __init__(self, api, **kwargs):
        super(Mousiki, self).__init__(**kwargs)
        self.api = api

    def build(self):
        p = Player()
        p.api = self.api
        return p


def main():
    api = API()
    api.connect()
    app = Mousiki(api)
    app.run()



if __name__ == '__main__':
    main()
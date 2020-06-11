from gi.repository import Gtk, GObject, Gio
from core.engine import GameEngine
from gui.controllers.main_window_controller import MainWindowController
from gui.controllers.theme_selection_controller import ThemeSelectionController
from os import path
from gui.controllers import gmenu_controller, about_controller
from gui.controllers.gmenu_controller import GmenuController
from gui.controllers.about_controller import AboutController
from properties import Directories
from model.configuration.user import UserConfig
from core.configuration.json.user import UserConfigManager


class Gnome2048Application(Gtk.Application):
    def __init__(self):
        Gtk.Application.__init__(self)
        engine = GameEngine()
        
        config_file = path.join(Directories.USER_CONFIG_DIR, "settings.json")
        self.config_manager = UserConfigManager(config_file)
        self.user_config = UserConfig()

        self.css_provider = Gtk.CssProvider()
        self.main_window_controller = MainWindowController(engine, self.css_provider)

        self.theme_selection_controller = ThemeSelectionController()
        self.theme_selection_controller.window.set_transient_for(self.main_window_controller.window)
        self.theme_selection_controller.register_theme_changed(self)

        self.gmenu_controller = GmenuController(self)
        self.about_controller = AboutController()
        about_win = self.about_controller.window
        main_win = self.main_window_controller.window
        about_win.set_transient_for(main_win)
        self.load_config()

        
    def load_config(self):
        self.user_config = self.config_manager.load()
        self.apply_theme(self.user_config.theme)
        
    def save_config(self):
        self.config_manager.save(self.user_config)

    def do_activate(self):
        self.set_app_menu(self.gmenu_controller.menu)
        self.main_window_controller.window.set_application(self)
        self.main_window_controller.show()

    def do_startup(self):
        Gtk.Application.do_startup(self)

    def show_theme_selection(self):
        try:
            self.theme_selection_controller.show(self.user_config.theme)
        except Exception as e:
            print(e)
            raise
        
    def show_about(self):
        self.about_controller.show()

    def theme_changed(self, theme):
        self.user_config.theme = theme
        self.save_config()
        self.apply_theme(theme)

    def apply_theme(self, theme):
        main_css = path.join(theme, "main.css")
        self.css_provider.load_from_path(main_css)


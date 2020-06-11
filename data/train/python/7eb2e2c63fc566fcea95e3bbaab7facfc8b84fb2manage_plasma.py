import sublime
import sublime_plugin

from api.plasma import manage

class ImportPlasmaCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        manage.import_selection(self.view, edit)


class ImportCustomPlasmaCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        def on_select(word):
            manage.import_token(self.view, edit, word)

        self.view.window().show_input_panel('Name: ', '', on_select, None, None)


class RemovePlasmaCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        manage.delete_selection(self.view, edit)


import sublime, sublime_plugin, os
# setting name : save_on_focus_lost
class toggleAutoSave(sublime_plugin.ApplicationCommand):
   def run(self):
      # load settings file
      settings = sublime.load_settings("Preferences.sublime-settings")
      current_auto_save = settings.get("save_on_focus_lost");

      if current_auto_save == True:
         settings.set("save_on_focus_lost", False)
         sublime.status_message("SAVE ON FOCUS LOST DEACTIVATED")
      else:
         settings.set("save_on_focus_lost", True)
         sublime.status_message("SAVE ON FOCUS LOST ACTIVATED")

      # save settings
      sublime.save_settings("Preferences.sublime-settings")


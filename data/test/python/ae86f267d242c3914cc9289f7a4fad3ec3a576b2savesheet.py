"""Abstraction layer for the save sheet"""
from automatorbase import AutomatorBase


# Constants
WINDOW_TITLE = 'Untitled*'
BUTTON_DONT_SAVE_INDEX = 2


class SaveSheet(AutomatorBase):
    """The select screen pops up when creating a new document in Automator"""
    @classmethod
    def get(cls):
        app = super(SaveSheet, cls).get()
        window = app.item_index(app.windows(WINDOW_TITLE), 0)
        if window:
            sheet = window.item_index(window.sheets(), 0)
            return sheet

    def dont_save(self):
        """Don't save button"""
        return self.item_index(self.buttons(), BUTTON_DONT_SAVE_INDEX)


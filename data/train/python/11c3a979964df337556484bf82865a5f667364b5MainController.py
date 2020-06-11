from MainInterfaceController import MainInterfaceController
from TelnetController import MeltedTelnetController, MeltedTelnetPollingController
from UnitController import InitialiseUnitsController, UnitsController
from PlaylistFileController import PlaylistFileController
from view import MainInterfaceView
from gi.repository import Gtk
from gi.repository import GObject
import Smelted_Settings

class MainController():

	main_interface_controller = None
	telnet_controller = None
	melted_telnet_polling_controller = None
	initialise_units_controller = None
	units_controller = None
	playlist_controller = None

	loaded = False

	def __init__(self):
		GObject.threads_init()

		# sets up telnet interface
		self.telnet_controller = MeltedTelnetController(Smelted_Settings.HOST, Smelted_Settings.PORT)
		self.melted_telnet_polling_controller = MeltedTelnetPollingController(Smelted_Settings.HOST, Smelted_Settings.PORT)

		# Sets up GUI with pygtk and their event listeners
		self.main_interface_controller = MainInterfaceController(self, self.telnet_controller)
		main_interface_controller = MainInterfaceView.MainInterfaceView(self.main_interface_controller)

		# manages melted units, existing units and their clips
		self.initialise_units_controller = InitialiseUnitsController(self, self.telnet_controller, self.on_loaded_from_telnet)

		# manages playlist file manipulation import/export
		self.playlist_file_controller = PlaylistFileController(self, self.telnet_controller)

		self.units_controller = UnitsController(self, self.telnet_controller)

		self.start_load_wait()

	def start_load_wait(self):
		while 1:
			if self.loaded:
				try:
					Gtk.main()
					self.telnet_controller.disconnect()
					self.melted_telnet_polling_controller.disconnect()
				except KeyboardInterrupt:
					if self.telnet_controller is not None:
						self.telnet_controller.disconnect()
						self.melted_telnet_polling_controller.disconnect()
				break

	def on_loaded_from_telnet(self):
		self.loaded = True

	def get_initialise_units_controller(self):
		return self.initialise_units_controller

	def get_units_controller(self):
		return self.units_controller

	def get_playlist_file_controller(self):
		return self.playlist_file_controller

	def get_main_interface_controller(self):
		return self.main_interface_controller
import gi

from ghue.controller import Controller
from ghue.device.hue import HueDeviceManager

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GLib
import phue

from .application import GHueApplication

if __name__ == '__main__':
    GLib.set_application_name("Philips Hue")
    controller = Controller()
    hue_device_manager = HueDeviceManager(bridge=phue.Bridge('philips-hue.local'),
                                          controller=controller)
    controller.add_device_manager(hue_device_manager)
    app = GHueApplication(controller)
    app.run(None)

__author__ = 'Eric Burlingame'

from main.controller import Controller
from main.channel_set import *

controller = Controller()

print controller.patch_channel(1, 1)
print controller.patch_channel(2, 2)
print controller.patch_channel(3, 3)

print controller.at(ChannelState(controller, "1 at 100"))

# name, insert = False, step = -1, fade = -1, wait = -1, all = -1, cued = False, channelSet = None
print controller.save_sequence("Test")
print controller.save_sequence("Test")
print controller.save_sequence("Test")

print controller.save_sequence("Test", False, -1, 10, 10)

print controller.list_sequences()

print controller.print_sequence("Test")


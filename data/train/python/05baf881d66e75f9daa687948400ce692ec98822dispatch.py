"""
Protocol command interpret/dispatch
"""
# Copyright (C) 2008 James Fargher

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.

import struct

import pyglet

from protocol.local import *

class HeaderDispatch(pyglet.event.EventDispatcher):
    """Dispatch packet unwrapping header"""
    def __init__(self):
        super(HeaderDispatch, self).__init__()

    def dispatch(self, data, address):
        ident, = struct.unpack("!6s", data[:6])
        if ident != "BOXMAN":
            return
        self.dispatch_event('received_header', data[6:], address)

HeaderDispatch.register_event_type('received_header')

class CommandDispatch(pyglet.event.EventDispatcher):
    """Dispatch packet unwrapping command type"""
    def __init__(self):
        super(CommandDispatch, self).__init__()

    def dispatch(self, data, address):
        cmd, = struct.unpack("!B", data[:1])
        if cmd == CMD_HELLO:
            self.dispatch_event('received_hello', data[1:], address)
        elif cmd == CMD_QUIT:
            self.dispatch_event('received_quit', data[1:], address)
        elif cmd == CMD_SPAWN:
            self.dispatch_event('received_spawn', data[1:], address)
        elif cmd == CMD_DESTROY:
            self.dispatch_event('received_destroy', data[1:], address)
        elif cmd == CMD_UPDATE:
            self.dispatch_event('received_update', data[1:], address)
        elif cmd == CMD_CLIENT:
            self.dispatch_event('received_client', data[1:], address)

CommandDispatch.register_event_type('received_hello')
CommandDispatch.register_event_type('received_quit')
CommandDispatch.register_event_type('received_spawn')
CommandDispatch.register_event_type('received_destroy')
CommandDispatch.register_event_type('received_update')
CommandDispatch.register_event_type('received_client')

class HelloDispatch(pyglet.event.EventDispatcher):
    """Dispatch packet unwrapping hello command"""
    def __init__(self):
        super(HelloDispatch, self).__init__()

    def dispatch(self, data, address):
        self.dispatch_event('on_hello', address)

HelloDispatch.register_event_type('on_hello')

class QuitDispatch(pyglet.event.EventDispatcher):
    """Dispatch packet unwrapping quit command"""
    def __init__(self):
        super(QuitDispatch, self).__init__()

    def dispatch(self, data, address):
        self.dispatch_event('on_quit', address)

QuitDispatch.register_event_type('on_quit')

class SpawnDispatch(pyglet.event.EventDispatcher):
    """Dispatch packet unwrapping spawn entity command"""
    def __init__(self):
        super(SpawnDispatch, self).__init__()

    def dispatch(self, data, address):
        type, id, color_r, color_g, color_b = struct.unpack("!BBBBB", data[:5])
        color = (color_r, color_g, color_b)
        self.dispatch_event('on_spawn_entity', type, id, color, address)

SpawnDispatch.register_event_type('on_spawn_entity')

class DestroyDispatch(pyglet.event.EventDispatcher):
    """Dispatch packet unwrapping destroy entity command"""
    def __init__(self):
        super(DestroyDispatch, self).__init__()

    def dispatch(self, data, address):
        id, = struct.unpack("!B", data[:1])
        self.dispatch_event('on_destroy_entity', id, address)

DestroyDispatch.register_event_type('on_destroy_entity')

class UpdateDispatch(pyglet.event.EventDispatcher):
    """Dispatch packet unwrapping update entity command"""
    def __init__(self):
        super(UpdateDispatch, self).__init__()

    def single(self, data, address):
        (id, posx, posy, direction, velx, vely) = \
                struct.unpack("!Bfffff", data[:21])
        pos = (posx, posy)
        vel = (velx, vely)
        self.dispatch_event('on_update_entity', id, pos, direction, vel,
                            address)

    def dispatch(self, data, address):
        count, = struct.unpack("!I", data[:4])
        for n in range(count):
            self.single(data[4+21*n:], address)

UpdateDispatch.register_event_type('on_update_entity')

class ClientDispatch(pyglet.event.EventDispatcher):
    """Dispatch packet unwrapping client state command"""
    def __init__(self, players):
        super(ClientDispatch, self).__init__()
        self.players = players

    def dispatch(self, data, address):
        forward, backward, rot_cw, rot_ccw = struct.unpack("!????", data[:4])
        self.dispatch_event('on_client', (forward, backward, rot_cw, rot_ccw),
                            address)

ClientDispatch.register_event_type('on_client')

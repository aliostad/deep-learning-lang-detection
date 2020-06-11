'''
Created on Mar 4, 2013

@author: Devindra

The main class. Links the program together and then starts the fun.
'''

from guppy import hpy
import atexit
import pyglet
from regicide.mvc import State
from regicide import model, view, controller
from regicide.view import window

def on_exit():
    print("Exiting...")
    #print(hpy().heap())
    # Previous values,
    # 33,010,620 / 41,962,120 | Jun 1, 2013

def init_states(window):
    game_model = model.game.Game()
    global_controller = controller.controller.Controller()
    
    print("Initializing Game States...")
    State('game',
        window     = window,
        model      = game_model,
        view       = view.game.GameView(window),
        controller = global_controller,
        commands   = controller.game.commands,
    )
    
    State('properties',
        window     = window,
        model      = game_model,
        view       = view.properties.PropertiesView(window),
        controller = global_controller,
        commands   = controller.properties.commands,
    )
    
    State('traits',
        window     = window,
        model      = game_model,
        view       = view.traits.TraitsView(window),
        controller = global_controller,
        commands   = controller.properties.commands,
    )
    
    State('actions',
        window     = window,
        model      = game_model,
        view       = view.actions.ActionsView(window),
        controller = global_controller,
        commands   = controller.properties.commands,
    )
    
    State('inventory',
        window     = window,
        model      = game_model,
        view       = view.inventory.InventoryView(window),
        controller = global_controller,
        commands   = controller.properties.commands,
    )
    
    State('world',
        window     = window,
        model      = game_model,
        view       = view.world.WorldView(window),
        controller = global_controller,
        commands   = controller.properties.commands,
    )
    
    State.set_current('game')
    game_model.next_turn()

if __name__ == '__main__':
    window = window.MasterView()
    init_states(window)
    atexit.register(on_exit)
    
    print("Starting Game Loop...")
    pyglet.app.run()
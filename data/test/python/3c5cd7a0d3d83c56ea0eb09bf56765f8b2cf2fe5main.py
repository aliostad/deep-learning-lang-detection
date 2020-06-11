import sys

from resources.resource_manager import GetImagePath

def GetPygameWindowAndController():
    """ Return the Pygame Window and Controller """
    from Screen.Pygame.Menu.MainMenu.main_menu_controller import MainMenuController
    from kao_gui.pygame.window import BuildWindow
    from InputProcessor import pygame_bindings
    window = BuildWindow(width=640, height=480, caption='Pokemon', 
                            iconFilename=GetImagePath('pokeball3.bmp'),
                            bindings=pygame_bindings.keyBindings)
    return window, MainMenuController()
    
def GetConsoleWindowAndController():
    """ Return the Console Window and Controller """
    from Screen.Console.Menu.MainMenu.main_menu_controller import MainMenuController
    from kao_gui.console.window import BuildWindow
    return BuildWindow(), MainMenuController()
    
def main(args):
    """ Start the game """
    if len(args) > 0 and args[0] == "-c":
        window, startController = GetConsoleWindowAndController()
    else:
        window, startController = GetPygameWindowAndController()
    try:
        startController.run()
    finally:
        window.close()

if __name__ == "__main__":
    main(sys.argv[1:])
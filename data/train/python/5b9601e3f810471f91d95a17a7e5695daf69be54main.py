import pygame
from pygame.locals import *
from engine.core import Engine
from sys import exit

def main():
    #If the television screen is 1920 x 1080
    #and the window of the game is 720 x 480
    #Then the engine will scale every item according to 1920 / 720 & 1080 / 480 ratio
    #Keep in mind to use the engine's blit function because it also 
    #scales the position offset according to 1920 / 720 & 1080 / 480 ratio
    window = Engine((720, 480), FPS=60)
    window.get_music('music/empty.ogg') #The engine plays music in the clear method, so load an (empty) ogg file

    background = window.load_image("img/background.png")

    while True:
        window.clear() #Fills the window with a black background and retreives events
        window.blit(background) #Blit a scaled image to position (0,0)
        window.safe_zone() #Show the safe_zone for ouya television screens ( 5% ) 
        window.stop() #If pressed escape button or controller.BUTTON_A exit the game

        if window.get_left_stick() != (0.0, 0.0): #For clean logging
            print("Controller > LSTICK : ",(window.get_left_stick()))
            
        if window.get_right_stick() != (0.0, 0.0): #For clean logging
            print("Controller > RSTICK : ",(window.get_right_stick()))
    
        if window.down(window.controller.BUTTON_O):     print("Controller >   DOWN : BUTTON_O")
        elif window.motion(window.controller.BUTTON_O): print("Controller > MOTION : BUTTON_O")
        elif window.up(window.controller.BUTTON_O):     print("Controller >     UP : BUTTON_O")
        
        if window.down(window.controller.BUTTON_U):     print("Controller >   DOWN : BUTTON_U")
        elif window.motion(window.controller.BUTTON_U): print("Controller > MOTION : BUTTON_U")
        elif window.up(window.controller.BUTTON_U):     print("Controller >     UP : BUTTON_U")
        
        if window.down(window.controller.BUTTON_Y):     print("Controller >   DOWN : BUTTON_Y")
        elif window.motion(window.controller.BUTTON_Y): print("Controller > MOTION : BUTTON_Y")
        elif window.up(window.controller.BUTTON_Y):     print("Controller >     UP : BUTTON_Y")
        
        if window.down(window.controller.BUTTON_A):     print("Controller >   DOWN : BUTTON_A")
        elif window.motion(window.controller.BUTTON_A): print("Controller > MOTION : BUTTON_A")
        elif window.up(window.controller.BUTTON_A):     print("Controller >     UP : BUTTON_A")
        
        if window.down(window.controller.BUTTON_L1):     print("Controller >   DOWN : BUTTON_L1")
        elif window.motion(window.controller.BUTTON_L1): print("Controller > MOTION : BUTTON_L1")
        elif window.up(window.controller.BUTTON_L1):     print("Controller >     UP : BUTTON_L1")
        
        if window.down(window.controller.BUTTON_L2):     print("Controller >   DOWN : BUTTON_L2")
        elif window.motion(window.controller.BUTTON_L2): print("Controller > MOTION : BUTTON_L2")
        elif window.up(window.controller.BUTTON_L2):     print("Controller >     UP : BUTTON_L2")
        
        if window.down(window.controller.BUTTON_L3):     print("Controller >   DOWN : BUTTON_L3")
        elif window.motion(window.controller.BUTTON_L3): print("Controller > MOTION : BUTTON_L3")
        elif window.up(window.controller.BUTTON_L3):     print("Controller >     UP : BUTTON_L3")
        
        if window.down(window.controller.BUTTON_R1):     print("Controller >   DOWN : BUTTON_R1")
        elif window.motion(window.controller.BUTTON_R1): print("Controller > MOTION : BUTTON_R1")
        elif window.up(window.controller.BUTTON_R1):     print("Controller >     UP : BUTTON_R1")
        
        if window.down(window.controller.BUTTON_R2):     print("Controller >   DOWN : BUTTON_R2")
        elif window.motion(window.controller.BUTTON_R2): print("Controller > MOTION : BUTTON_R2")
        elif window.up(window.controller.BUTTON_R2):     print("Controller >     UP : BUTTON_R2")
        
        if window.down(window.controller.BUTTON_R3):     print("Controller >   DOWN : BUTTON_R3")
        elif window.motion(window.controller.BUTTON_R3): print("Controller > MOTION : BUTTON_R3")
        elif window.up(window.controller.BUTTON_R3):     print("Controller >     UP : BUTTON_R3")
        
        if window.down(window.controller.BUTTON_DPAD_UP):     print("Controller >   DOWN : BUTTON_DPAD_UP")
        elif window.motion(window.controller.BUTTON_DPAD_UP): print("Controller > MOTION : BUTTON_DPAD_UP")
        elif window.up(window.controller.BUTTON_DPAD_UP):     print("Controller >     UP : BUTTON_DPAD_UP")
        
        if window.down(window.controller.BUTTON_DPAD_DOWN):     print("Controller >   DOWN : BUTTON_DPAD_DOWN")
        elif window.motion(window.controller.BUTTON_DPAD_DOWN): print("Controller > MOTION : BUTTON_DPAD_DOWN")
        elif window.up(window.controller.BUTTON_DPAD_DOWN):     print("Controller >     UP : BUTTON_DPAD_DOWN")
        
        if window.down(window.controller.BUTTON_DPAD_LEFT):     print("Controller >   DOWN : BUTTON_DPAD_LEFT")
        elif window.motion(window.controller.BUTTON_DPAD_LEFT): print("Controller > MOTION : BUTTON_DPAD_LEFT")
        elif window.up(window.controller.BUTTON_DPAD_LEFT):     print("Controller >     UP : BUTTON_DPAD_LEFT")
        
        if window.down(window.controller.BUTTON_DPAD_RIGHT):     print("Controller >   DOWN : BUTTON_DPAD_RIGHT")
        elif window.motion(window.controller.BUTTON_DPAD_RIGHT): print("Controller > MOTION : BUTTON_DPAD_RIGHT")
        elif window.up(window.controller.BUTTON_DPAD_RIGHT):     print("Controller >     UP : BUTTON_DPAD_RIGHT")
        
        if window.down(window.controller.BUTTON_MENU):     print("Controller >   DOWN : BUTTON_MENU")
        elif window.motion(window.controller.BUTTON_MENU): print("Controller > MOTION : BUTTON_MENU")
        elif window.up(window.controller.BUTTON_MENU):     print("Controller >     UP : BUTTON_MENU")

        window.update() #Updates the events, renders images and ticks the FPS Clock

    pygame.quit()
    exit()

if __name__ == '__main__':
    main()

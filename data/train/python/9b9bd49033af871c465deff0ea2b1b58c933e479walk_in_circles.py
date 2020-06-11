# -*- coding: utf-8 -*-
import time

from rpgs.characters.models import Character
from rpgs.characters.controllers.controller import Controller

def walk_along(controller):    
    while(1):
        #-> x5
        for i in range(0,5):
            controller.do_walk(3,all=True)
            time.sleep(1)
    
        #\/ x 2
        for i in range(0,2):
            controller.do_walk(2,all=True)
            time.sleep(1)
    
        #<- x 5
        for i in range(0,5):
            controller.do_walk(4,all=True)
            time.sleep(1)
    
        #/\ x 2     
        for i in range(0,2):
            controller.do_walk(1,all=True)
            time.sleep(1)
        
def run():
    c2 = Character.objects.get(pk=1)
    c2.coordinates=[7,2]
    c2.save()
    
    controller = Controller()
    controller.add_character(c2)
    walk_along(controller)
    
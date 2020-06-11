'''
Created on Jan 6, 2014

@author: Shawn
'''

from org.aesrc.controllers import MainController
import threading
import time

class AesrcMain(threading.Thread):
    '''
    classdocs
    '''
    # var to kill sub threads
    running = True
    
    # Main controller
    mainController = 1
    
    def __init__(self):
        '''
        Constructor
        '''
        threading.Thread.__init__(self)
        
        print "Starting Main Controller Thread"
        
        # Create a new main controller
        self.mainController = MainController.MainController()
        
        # Intialize the controller
        self.mainController.initMainController()
        
    def run(self):
        print "Running Main Controller Thread"
        
        while self.running:
            # Update every 2 minutes
            self.mainController.runMainController()
            time.sleep(120)
        
        print "Exit Main Controller Thread"




# Eof
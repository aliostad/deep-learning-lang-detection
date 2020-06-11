'''
Created on 7 April 2014

@author: Sven, Bjorn, Martin
'''

import sys
from controller import gameStateController
from PyQt5.QtWidgets import QApplication
 
def main():
    '''
    Main, creates an app and a gameStateController
    '''
    
    # Create an application and set properties
    app = QApplication(sys.argv)
    app.setOrganizationName("Group 13")
    app.setOrganizationDomain("group13.se")
    app.setApplicationName("Solitaire")
    
    # Create gameStateController (controller in MVC)
    gameStateController.gameStateController()

    sys.exit(app.exec_())

if __name__ == '__main__':
    main()
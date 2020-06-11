#==================================================================================================
#	Imports
#==================================================================================================
import serial	#Import the serial library from python
#==================================================================================================
#	
#==================================================================================================




#==================================================================================================
#	Controller Class
#==================================================================================================
class controller:
    # Initization function for the class
    def __init__(self,com_port,baudrate):                           
        self.controller_port=com_port           # Com port which the controller is connected
        self.controller_baudrate=baudrate       # Baudrate which the controller is running
        
    # Function that checks to see if the controller is connected
    def iscontrollerconnected(self):
        try:
            controller=serial.Serial(self.controller_port,self.controller_baudrate,timeout=1)  
            controller.write("c")                                                              
            while 1:                                                                            
                ping_back_value=controller.read()                                             
                if ping_back_value=="1":                                                        
                    controller.close()                                                          
                    return True
                else:
                    controller.close()                                                                              return False
        except:
            return False
    
    # Checks the status of the left joystick's x axis (1 for right, 0 for neutral, 2 for left
    # and -1 if it cannot complete the command
    def checkleftjoystickx(self):
        if self.iscontrollerconnected():
            controller=serial.Serial(self.controller_port,self.controller_baudrate,timeout=1)
            controller.write("j")
            controller.write("l")
            controller.write("x")
            while 1:
                reading=controller.read()
                controller.close()
                return reading
        else:
            return -1
    # Checks the status of the right joystick's y axis (1 for up, 0 for neutral, 2 for down, 
    # and -1 if it cannot complete the command
    def checkleftjoysticky(self):
        if self.iscontrollerconnected():
            controller=serial.Serial(self.controller_port,self.controller_baudrate,timeout=1)
            controller.write("j")
            controller.write("l")
            controller.write("y")
            while 1:
                reading=controller.read()
                controller.close()
                return reading
        else:
            return -1
    # Checks the status of the right joystick's x axis (1 for right, 0 for neutral, 2 for 
    # left, and -1 if it cannot complete the command
    def checkrightjoystickx(self):
        if self.iscontrollerconnected():
            controller=serial.Serial(self.controller_port,self.controller_baudrate,timeout=1)
            controller.write("j")
            controller.write("r")
            controller.write("x")
            while 1:
                reading=controller.read()
                controller.close()
                return reading
        else:
            return -1
    # Checks the status of the right joystick's y axis (1 for up, 0 for neutral, 2 for down
    # and -1 if it cannot complete the command
    def checkrightjoysticky(self):
        if self.iscontrollerconnected():
            controller=serial.Serial(self.controller_port,self.controller_baudrate,timeout=1)
            controller.write("j")
            controller.write("r")
            controller.write("y")
            while 1:
                reading=controller.read()
                controller.close()
                return reading
        else:
            return -1
    # Checks the status of the yellow button (1 for pressed, 0 for unpressed, and -1 if it cannot 
    # complete the command
    def checkyellowbutton(self):
        if self.iscontrollerconnected():
            controller=serial.Serial(self.controller_port,self.controller_baudrate,timeout=1)
            controller.write("b")
            controller.write("y")
            while 1:
                reading=controller.read()
                controller.close()
                return reading
        else:
            return -1
    # Checks the status of the red button (1 for pressed, 0 for unpressed, and -1 if it cannot
    # complete the command
    def checkredbutton(self):
        if self.iscontrollerconnected():
            controller=serial.Serial(self.controller_port,self.controller_baudrate,timeout=1)
            controller.write("b")
            controller.write("r")
            while 1:
                reading=controller.read()
                controller.close()
                return reading
        else:
            return -1
       
#==================================================================================================
#	
#==================================================================================================

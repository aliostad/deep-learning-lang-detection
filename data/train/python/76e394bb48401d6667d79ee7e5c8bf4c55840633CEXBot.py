'''
Main Bot file. 
'''
import logging
import time
from threading import Timer
from Controllers.LogController import Log_Controller
from Controllers.DataController import Data_Controller
from Controllers.RequestController import RequestController

#====== Controller initialization ======
logging_controller = Log_Controller()
logg = logging_controller.get_logger("Main")

data_controller = Data_Controller(logging_controller.get_logger("Data Controller"),RequestController(logging_controller.get_logger("Request Controller")))
#====== Bot vars ======
running = True

#====== Bot Functions =====    
def tick_data():
    if(running):
        data_controller.add_point()
        Timer(10,tick_data).start()
        
#====== Bot program start =====
logg.log(logging.INFO,time.asctime()+": CEXBot starting up")
logg.log(logging.INFO,time.asctime()+": NOTE!!! THE USER SHOULD WHATE FOR ATLEAST 10 ACTION DESCRIPTIONS BEFORE ATTEMPTING ANYTHING")
tick_data()

while(running):
    command = ""
    command = input()
    if(command == "exit"):
        print("CEXBot closing.")
        logg.log(logging.INFO,time.asctime()+": CEXBot closing")
        running = False   

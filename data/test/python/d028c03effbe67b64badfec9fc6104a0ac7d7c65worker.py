import time
from threading import Thread
from web import database, db_lock
from .crockpi.controller import Controller

class ControllerThread(Thread):
    running = False
    instance = None
    data = []

    def __init__(self):
        Thread.__init__(self)

    def set_target(self, target):
        self.target = target

    def run(self):
        if ControllerThread.running:
            return

        ControllerThread.running = True
        ControllerThread.instance = self
        self.controller = Controller(values=ControllerThread.data, database=database)
        self.controller.run(self.target)

    def stop(self):
        print('stopping thread...')
        self.controller.stop()
        self.controller = None
        ControllerThread.instance.join()
        ControllerThread.instance = None
        ControllerThread.running = False
        ControllerThread.data.clear()

    def get_target(self):
        return self.target

def start_controller_thread(target_temp, data):
    cleanup()
    print('starting controller')

    ControllerThread.data.clear()
    ControllerThread.data.extend(data)

    crockpi_controller = ControllerThread()

    crockpi_controller.set_target(target_temp)
    crockpi_controller.start()

def cleanup():
    if ControllerThread.instance:
        ControllerThread.instance.stop()
        print('stopped controller')

def resume_session():
    if ControllerThread.running: return
    current = database.get_active_session()
    if not current: return

    print('resuming control session at', current.target_temp)
    
    data = database.retrieve_data(current)
    start_controller_thread(current.target_temp, data)


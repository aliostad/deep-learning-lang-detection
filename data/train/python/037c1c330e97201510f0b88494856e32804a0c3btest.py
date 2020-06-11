from ClientThread import ClientThread
from CentralController import CentralController
from LocalController import LocalController
import time
import threading 

if __name__ == "__main__":
    port = 40018
    threads = []

    central_controller = CentralController(port)
    central_controller.daemon = True
    central_controller.start()
    
    for i in xrange(1,4):
        local = LocalController('127.0.0.1',port,'n00'+str(i))
        local.start()
        threads.append(local)

    for thread in threads:
        thread.join()
    
    time.sleep(2)
    history = central_controller.stop()
    print "HISTORY:"
    for node in history:
        print node
        states = history[node]
        for state in states:
            print "   " + state.__str__()


# dist_busbroker.py
#
# Message broker that accepts update data from the bus monitor
# and broadcasts it onto a collection of replicated servers

import tasklib
import taskdist

class BusDbBrokerTask(tasklib.Task):
    def __init__(self,targets):
        super().__init__(name="busdbbroker")
        self.targets = targets

    def run(self):
        while True:
            msg = self.recv()
            for target in self.targets:
                tasklib.send(target,msg)
            
if __name__ == '__main__':
    import time
    import logging
    logging.basicConfig(level=logging.INFO)

    # Start my message dispatcher
    taskdist.start_dispatcher(("localhost",16000),authkey=b"peekaboo")
    
    # Register proxies to the different servers
    taskdist.proxy("busdb-1","busdb",("localhost",17000),authkey=b"peekaboo")
    taskdist.proxy("busdb-2","busdb",("localhost",17001),authkey=b"peekaboo")

    # Start the message broker
    broker_task = BusDbBrokerTask(["busdb-1","busdb-2"])
    broker_task.start()
    tasklib.register("busdb", broker_task)

    # Spin
    while True:
        time.sleep(1)

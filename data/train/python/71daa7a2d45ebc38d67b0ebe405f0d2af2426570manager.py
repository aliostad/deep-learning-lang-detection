from irc import Irc
from broker import Broker
from events import Quit as QuitEvent
from multiprocessing import Process, Queue
import settings
from os import path
from imp import load_source

class Manager(object):
    def __init__(self):
        self.rxq = Queue()
        self.txq = Queue()
        self.inputs = []

    def start(self):
        broker = Broker(self.rxq, self.txq)
        broker.find_plugins()
        irc = Irc(self.rxq, self.txq)
        self.irc_p = Process(target=irc.start)
        self.broker_p = Process(target=broker.start)
        self.irc_p.start()
        self.broker_p.start()
        
        for input in settings.INPUTS:
            input_path = path.join(settings.INPUTS_DIR, "%s.py" % input)
            if path.isfile(input_path):
                module = load_source(input, input_path)
                p = Process(target=module.input, args=(self.rxq,))
                self.inputs.append(p)
                p.start()
            else:
                # warning
                pass
        
    def end(self):
        """
Sends quit event to both queues and waits for them to run their course.
        """
        self.rxq.put(QuitEvent())
        self.txq.put(QuitEvent())
        self.end_safely(self.broker_p)
        self.end_safely(self.irc_p)
        for input in self.inputs:
            input.terminate()

    def end_safely(self, process):
        """
Attempts to join the process. If the process is still alive. Kills it.
        """
        process.join(timeout=settings.TIMEOUT)
        if process.is_alive():
            process.terminate()

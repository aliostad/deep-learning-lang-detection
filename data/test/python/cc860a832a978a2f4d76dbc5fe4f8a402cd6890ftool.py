#!/usr/bin/python

from multiprocessing import Pool
import rabidmongoose.worker
import rabidmongoose.broker
from time import sleep
import signal
from sys import argv

BROKER_POOL = None
WORKER_POOL = None

def init_signal():
    signal.signal(signal.SIGINT, signal.SIG_IGN)
    
def handler(signum, frame):
    print signum, frame
    BROKER_POOL.terminate()
    WORKER_POOL.terminate()
    BROKER_POOL.join()
    WORKER_POOL.join()
    exit(0)
    
def broker_pool_fn():
    rabidmongoose.broker.start()

def worker_pool_fn():
    rabidmongoose.worker.start()

def start(num_brokers, num_workers):
    global BROKER_POOL
    global WORKER_POOL
    
    BROKER_POOL = Pool(num_brokers+1, init_signal)
    for i in xrange(num_brokers):
        BROKER_POOL.apply_async(broker_pool_fn)
    WORKER_POOL = Pool(num_workers, init_signal)
    for i in xrange(num_workers):
        WORKER_POOL.apply_async(worker_pool_fn)
    
    signal.signal(signal.SIGINT, handler)
    signal.signal(signal.SIGTERM, handler)
    while True:
        sleep(20)
        
if __name__ == '__main__':
    start(1, int(argv[1]))
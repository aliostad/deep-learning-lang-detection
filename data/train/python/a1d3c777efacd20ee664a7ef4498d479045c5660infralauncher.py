# encoding: utf-8
import threading
from time import sleep
from distark.majordaemon.broker.mdbroker import main as bmain
from distark.majordaemon.worker.mdworker import main as wmain
from distarkcli.utils.MyConfiguration import Configuration


class WorkerThread(threading.Thread):
    _worker = None
    _lock = None
    _confpath = None

    def __init__(self, lock, confpath):
        threading.Thread.__init__(self)
        self._lock = lock
        self._confpath = confpath

    def stop(self):
        if self._worker:
            self._worker.stop()

    def isup(self):
        if self._worker:
            return self._worker.isup()
        else:
            return False

    def run(self):
        self._lock.acquire()
        self._worker = wmain(self._confpath)
        self._lock.release()
        self._worker.work()


class BrokerThread(threading.Thread):
    _broker = None
    _lock = None
    _confpath = None

    def __init__(self, lock, confpath):
        threading.Thread.__init__(self)
        self._lock = lock
        self._confpath = confpath

    def stop(self):
        if self._broker:
            self._broker.stop()

    def isup(self):
        res = False
        if self._broker:
            if self._broker.isup():
                res = True
        return res

    def run(self):
        self._lock.acquire()
        self._broker = bmain(self._confpath)
        self._lock.release()
        self._broker.mediate()  # run forever


class InfraLauncher(object):

    brokerlist = []
    workerlist = []
    conf = None

    @staticmethod
    def waitbrokers():

        # wait for broker to be up
        maxtry = 0
        while maxtry < 5:
            maxtry += 1
            res = True
            for b in InfraLauncher.brokerlist:
                print b
                if not(b.isup()):
                    res = False
            if not(res):
                sleep(0.3)
            else:
                break
        if not(res):
            assert 0, 'broker not started'

    @staticmethod
    def waitworkers():
        # wait for broker to be up
        maxtry = 0
        while maxtry < 5:
            maxtry += 1
            res = True
            for b in InfraLauncher.workerlist:
                if not(b.isup()):
                    res = False
            if not(res):
                sleep(0.3)
            else:
                break
        if not(res):
            assert 0, 'worker not started'

    @staticmethod
    def launch(confpath, nbworker):

        print '###################################'
        print confpath
        print '###################################'

        if len(InfraLauncher.brokerlist) == 0:
            lock = threading.Lock()
            # launch broker
            InfraLauncher.brokerlist.append(BrokerThread(lock, confpath))
            for _ in range(nbworker):
                # launch worker
                InfraLauncher.workerlist.append(WorkerThread(lock, confpath))

            for b in InfraLauncher.brokerlist:
                b.start()
            InfraLauncher.waitbrokers()

            for w in InfraLauncher.workerlist:
                w.start()
            InfraLauncher.waitworkers()

    @staticmethod
    def stop():
        print "Stop infra !!!!!!"
        for b in InfraLauncher.brokerlist:
            b.stop()

        for w in InfraLauncher.workerlist:
            w.stop()

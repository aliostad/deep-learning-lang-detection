#!/usr/bin/env python

import bisect
import cmd
import random
import shlex
import time

from collections import deque
from functools import partial
from multiprocessing import Process, Queue, Manager

from Queue import Empty

# Workaround for tab completion on Mac OS X
import readline
readline.parse_and_bind('bind ^I rl_complete')
# End workaround

WORKERS = 3
TIMEOUT = 5


class BrokerMonkey(object):
    def __init__(self, broker_q):
        self.broker_q = broker_q

    def delay(self, tgt, msg_type, delay):
        self.broker_q.put(('delay', tgt, msg_type, delay))


def broker_register(manager, broker_q, pid):
    inbox = manager.Queue()
    broker_q.put(('register', pid, inbox))
    return inbox


def broker_send(broker_q, src, dst, msg):
    broker_q.put(('send', src, dst, msg))


def broker_init():
    q = Queue()
    p = Process(target=broker, args=((q,)))
    p.start()
    return p, q


def _broker_register(queues, pid, queue):
    queues[pid] = queue


def _broker_send(queues, src, dst, msg):
    queues[dst].put((src, msg), False)


def _broker_set_delay(delays, tgt, msg_type, delay):
    if delay <= 0:
        try:
            del delays[(tgt, msg_type)]
        except KeyError:
            pass
    else:
        delays[(tgt, msg_type)] = delay


def _broker_maybe_send(queues, delays, delayed, src, dst, payload):
    msg_type = payload[0]
    try:
        delay = delays[(dst, msg_type)]
        send_time = time.time() + (delay / 1000.0)
        bisect.insort(delayed, (send_time, src, dst, payload))
    except KeyError:
        _broker_send(queues, src, dst, payload)


def _broker_maybe_send_delayed(queues, delayed):
    now = time.time()
    for msg in delayed:
        send_time, src, dst, payload = msg
        if now >= send_time:
            _broker_send(queues, src, dst, payload)
            delayed.pop(0)
        else:
            # Short circuit as the list is sorted by send time on insertion
            break


def broker(inbox):
    queues = {}
    delays = {}
    delayed = []
    while True:
        _broker_maybe_send_delayed(queues, delayed)
        try:
            msg = inbox.get(timeout=1)
        except Empty:
            continue
        if msg[0] == 'register':
            pid = msg[1]
            queue = msg[2]
            _broker_register(queues, pid, queue)
        if msg[0] == 'send':
            src = msg[1]
            dst = msg[2]
            payload = msg[3]
            _broker_maybe_send(queues, delays, delayed, src, dst, payload)
        if msg[0] == 'delay':
            tgt = msg[1]
            msg_type = msg[2]
            delay = msg[3]
            _broker_set_delay(delays, tgt, msg_type, delay)


def _worker_send(broker_q, src, dst, msg):
    broker_q.put(('send', src, dst, msg), False)


def receive(q):
    try:
        return q.get(timeout=TIMEOUT)
    except Empty:
        return None, None


def maybe_receive_msg(pid, q, debug=None):
    sender_pid, msg = receive(q)
    if msg:
        output = '{0} received message from {1}: {2}'.format(
            pid,
            sender_pid,
            msg
        )
        if debug:
            debug.put(output)
        return sender_pid, msg
    else:
        return None, None


def worker(pid, queue, broker_q, debug=None):
    state = {}
    peers = []
    while True:
        src_pid, msg = maybe_receive_msg(pid, queue, debug)
        if not msg:
            continue
        elif msg[0] == 'send':
            dst_pid = msg[1]
            peer_msg = msg[2:]
            _worker_send(broker_q, pid, dst_pid, peer_msg)
        elif msg[0] == 'ping':
            _worker_send(broker_q, pid, src_pid, 'pong')
        elif msg[0] == 'put':
            key = msg[1]
            value = msg[2]
            state[key] = value
            _worker_send(broker_q, pid, src_pid, ('ok', ))
        elif msg[0] == 'get':
            key = msg[1]
            try:
                resp = ('ok', state[key])
            except KeyError:
                resp = ('error', 'not_found')
            _worker_send(broker_q, pid, src_pid, resp)
        elif msg[0] == 'cput':
            key = msg[1]
            value = msg[2]
            _worker_cput(broker_q, peers, pid, key, value)
            _worker_send(broker_q, pid, src_pid, ('ok', ))
        elif msg[0] == 'cget':
            key = msg[1]
            try:
                resp = ('ok', state[key])
            except KeyError:
                resp = ('error', 'not_found')
            _worker_send(broker_q, pid, src_pid, resp)
        elif msg[0] == 'register':
            peer_pid = msg[1]
            peers.append(peer_pid)


def _worker_cput(broker_q, peers, pid, key, value):
    for worker_pid in peers:
        _worker_send(broker_q, pid, worker_pid, ('put', key, value))


def init(num_workers=WORKERS, debug=False):
    worker_procs = deque()
    broker_proc, broker_q = broker_init()
    m = Manager()
    register_fun = partial(broker_register, m, broker_q)
    debug_queues = debug and {}
    worker_pids = range(0, num_workers)
    for pid in worker_pids:
        inbox = register_fun(pid)
        if debug:
            debug_queues[pid] = Queue()
        worker_proc = Process(
            target=worker,
            args=(pid, inbox, broker_q),
            kwargs={"debug": debug and debug_queues[pid]}
        )
        worker_proc.start()
        worker_procs.append(worker_proc)
    send_fun = partial(broker_send, broker_q)
    for tgt_pid in worker_pids:
        for pid in worker_pids:
            send_fun(-1, tgt_pid, ('register', pid))
    broker_monkey = BrokerMonkey(broker_q)
    return (
        worker_procs,
        broker_proc,
        send_fun,
        register_fun,
        broker_monkey,
        debug_queues
    )


class NoedzShell(cmd.Cmd):
    file = None

    def __init__(
            self, worker_procs, broker_proc, send_fun, broker_register,
            debug_queues):
        cmd.Cmd.__init__(self, completekey='TAB')
        self.pid = -1
        self.inbox = broker_register(self.pid)
        self.broker_proc = broker_proc
        self.worker_procs = worker_procs
        self.send = send_fun
        self.debug_queues = debug_queues
        self.prompt = 'noedz > '

    def do_exit(self, arg):
        for p in self.worker_procs:
            p.terminate()
        self.broker_proc.terminate()
        exit(0)

    def do_debug_queue(self, arg):
        if arg:
            queue = self.debug_queues[int(arg)]
        else:
            queue = self.inbox
        try:
            print queue.get(False)
        except Empty:
            print 'Nothing in the queue'

    def do_send(self, arg):
        args = shlex.split(arg)
        dst = int(args[0])
        msg = self._parse_args(args[1:])
        self.send(self.pid, dst, msg)

    def _parse_fun(self, arg):
        try:
            return int(arg)
        except ValueError:
            return arg

    def _parse_args(self, args):
        return [self._parse_fun(arg) for arg in args]


if __name__ == '__main__':
    random.seed(time.time())
    worker_procs, broker_proc, send_fun, broker_register, broker_monkey,\
        debug_queues = init(num_workers=3, debug=True)
    NoedzShell(
        worker_procs,
        broker_proc,
        send_fun,
        broker_register,
        broker_monkey,
        debug_queues
    ).cmdloop()

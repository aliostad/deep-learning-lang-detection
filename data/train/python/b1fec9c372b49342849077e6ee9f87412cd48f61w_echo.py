#! /usr/bin/env python
"""An echo server
"""
# Overview
# This is an echo server for Jozabad

import jza

broker = "tcp://localhost:5555"
address = "0001"

if __name__ == '__main__':
    verbose = 1
    dir = jza.direction_bidirectional
    thru = jza.t_4800bps

    ctx = jza.zctx_new();
    jza.zclock_log("connecting to broker socket at {0}...".format(broker))
    sock = jza.zsocket_new(ctx, 5)
    jza.zmq_connect(sock, broker)
    s = "connecting to broker as '{0}', {1} {2}..."\
        .format(broker, jza.direction_name(dir), jza.throughput_name(thru))
    jza.zclock_log(s);

    jza.joza_msg_send_connect(sock, address, dir);

    msg_in = jza.joza_msg_recv(sock);
    jza.joza_msg_dump(msg_in);

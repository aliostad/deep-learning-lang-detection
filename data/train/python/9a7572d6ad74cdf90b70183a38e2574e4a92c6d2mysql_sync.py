#!/usr/bin/env python

__author__ = 'jintao'

import thread, threading, time

from Packet import Packet, PacketManage
from BinlogEvent import BinlogEventManage
from MYSQLChannel import MYSQLChannel
from BinlogDataManage import BinlogDataManage
from ConfigLoader import ConfigLoader
from BinlogHandle import HandlerThread, BinlogHandlerManage, BinlogHandler

global_config = ConfigLoader()
global_binlog_event_manage = BinlogEventManage()
global_binlog_data_manage = BinlogDataManage()
global_packet_manage = PacketManage(global_binlog_event_manage, global_binlog_data_manage)
global_signal = threading.Event()

def start_sync():
    global global_config
    start_pos = global_config.pos()
    start_binlog = global_config.binlog()
    global_binlog_data_manage.set_filename(start_binlog)
    global_binlog_data_manage.set_position(start_pos)

    while True:
        mysql_channel = MYSQLChannel(global_config.host(), global_config.port(), global_config.username(), global_config.password(), global_config.database(), global_config.master_id())
        if mysql_channel.initChannel() == False:
            return False
        recv_data = mysql_channel.dump_binlog(start_pos, start_binlog)
        print 'dump...'
        if recv_data != '':
            (packet_list, count) = global_packet_manage.parse(recv_data)
            start_pos = global_binlog_data_manage.position()
            start_binlog = global_binlog_data_manage.filename()
            global_signal.set()
            mysql_channel.close()
        threading._sleep(3)

def init():
    if global_config.load('mysql_sync.conf') == False:
        return False

    return True

def main():
    if init() == False:
        return

    binlog_handler_manage = BinlogHandlerManage(global_binlog_data_manage)
    binlog_handler1 = BinlogHandler("test_handler")
    binlog_handler_manage.add_last_handler(binlog_handler1)
    thread = HandlerThread(global_signal, global_binlog_data_manage, binlog_handler_manage)

    thread.setDaemon(True)
    thread.start()

    start_sync()

main()
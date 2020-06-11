#!/usr/bin/env python

"""
Example JSON data for dispatch process.

-- request from client --
{
    "request_type" : "add_monitor_entry", # or "update_monitor_entry", "delete_monitor_entry"
    "netid" : "xxxxxxxx",
    "crn" : "xxxxx",
    "mode" : "x"
}
"""

import socket
import json
import multiprocessing
import logging

import database
from monitor import Monitor

class Dispatch(object):
    
    _TIMEOUT = 600
    
    def __init__(self, conn, address):
        self.conn = conn
        self.address = address
        self.db = database.DatabaseCommunicator()
        # self.conn.settimeout(_TIMEOUT)
        self.logger = logging.getLogger('Dispatch')
        logging.basicConfig(level=logging.DEBUG)
        
        self.logger.debug('dispatch launched')
    
    def _monitorLauncher(self, crn):
        monitor = Monitor(crn)
    
    def listen(self):
        try:
            while True:
                # try:
                dispatchRequest = self.conn.recv(2048)
                # except socket.timeout:
                #    self.logger.debug('Timeout!')
                #    break
                if dispatchRequest == '':
                    self.logger.debug('Socket closed from client')
                    return
                if dispatchRequest == '\n':
                    continue
                self.logger.info('Dispatch request received.')
                self.logger.debug(dispatchRequest)
                
                dispatchRequestJSON = json.loads(dispatchRequest)
                requestType = dispatchRequestJSON['request_type']
                netid = dispatchRequestJSON['netid']
                crn = dispatchRequestJSON['crn']
                mode = dispatchRequestJSON['mode']
                
                if requestType == 'add_monitor_entry':
                    notificationInterval = dispatchRequestJSON['notification_interval']
                    self.logger.debug('parse interval = ' + str(notificationInterval))
                    self.db.addMonitorEntry(netid, crn, mode, notificationInterval)
                    self.logger.debug('add entry')

                    if self.db.newMonitorRequired(crn):
                        # new monitor process
                        process = multiprocessing.Process(target=self._monitorLauncher, args=(crn))
                        process.daemon = True
                        process.start()
                    dispatchResponse = dict(request_type='add_monitor_entry', request_status='Accepted')
                if requestType == 'update_monitor_entry':
                    notificationInterval = dispatchRequestJSON['notification_interval']
                    lastNotification = dispatchRequestJSON['last_notification']
                    self.db.updateMonitorEntry(netid, crn, mode, notificationInterval, lastNotification)
                    dispatchResponse = dict(request_type='update_monitor_entry', request_status='Accepted')
                if requestType == 'delete_monitor_entry':
                    self.db.deleteMonitorEntry(netid, crn)
                    dispatchResponse = dict(request_type='delete_monitor_entry', request_status='Accepted')
                self.conn.sendall(json.dumps(dispatchResponse) + '\n')
                continue
        except:
            self.logger.debug('Unknown error')
        finally:
            self.logger.debug('Closing current socket')
            self.conn.close()


# coding: GB2312
#!/usr/bin/env python

"""
SMPP,SuperMap Parallel Processor
Desc:
	The dispatch jobs example, show the code logic.
Author: WangEQ, SuperMap GIS Institute.
All rights reserved.
"""

import math
import time
import sys

import logging
from tornado.ioloop import IOLoop
from stormed import Connection, Message
import simplejson as json

import SMB
import SMB_Dispatch

#=================================================================
def dispatchJobs():
	for i in range(0,10):
		job = build_Job(r'Job %2d'%i)
		print "Dispatch Job:",i
		SMB.send_job(job)
		
if __name__ == '__main__':
	SMB_Dispatch.handle_Dispatcher = dispatchJobs
	SMB.start(SMB_Dispatch.on_connect)

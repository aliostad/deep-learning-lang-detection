#coding=utf-8
#!/bin/python
"""
=================================================================
 @FileName:   Sender
 @author  :   houbolin<houbl@foxmail.com>
 @descrption: 添加任务到队列中
 @
=================================================================
"""
import beanstalkc
import logging
import logging.handlers
import os
import sys
import confManage
#
#添加任务
#添加任务时,要求指定队列名
#
def addTask( queuename,msg ):
	beanstalk.use( queuename )
	beanstalk.put( msg )

if __name__ == '__main__':
	beanstalk = beanstalkc.Connection( confManage.host(),confManage.port() )

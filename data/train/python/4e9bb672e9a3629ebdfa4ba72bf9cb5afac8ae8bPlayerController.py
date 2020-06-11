#!/usr/bin/env python
###############################################################################
##                                                                           ##
##   ##  ##   #####   ###   ##   ##       ##      ####     ####  ###   ##    ##
##   ## ##    ##      ## ## ##   ##     ##  ##    ##  ##    ##   ## ## ##    ##
##   ####     #####   ##  ####   ##    ##    ##   ##   ##   ##   ##  ####    ##
##   ## ##    ##      ##   ###   ##     ##  ##    ## ##     ##   ##   ###    ##
##   ##  ##   #####   ##    ##   #####    ##      ###      ####  ##    ##    ##
##                                                                           ##
##  File : PlayerController                                                  ##
##  Comment :                                                                ##
##  version :                                                                ##
##  since :                                                                  ##
##                                                                           ##
###############################################################################

from Controller import Controller

class PlayerController(Controller):

  	def init(self):
	  	self.__models = ['Player']

	def sendMsg(self, params):
		print "sendAll"
		self.sendAll("crotte")

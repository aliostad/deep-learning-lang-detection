#!/usr/bin/python
# -*- coding:utf-8 -*-

def GetNowAccount():
	accFile = open("../config/account.in", "r")
	brokerID = accFile.readline()[:-1]
	userID = accFile.readline()[:-1]
	password = accFile.readline()[:-1]
	address = accFile.readline()[:-1]
	marketPort = accFile.readline()[:-1]
	return brokerID, userID, password, address, marketPort

def SaveNewAccount(brokerID, userID, password, address, marketPort):
	accFile = open("../config/account.in", "w")
	accFile.write(str(brokerID))
	accFile.write('\n')
	accFile.write(userID)
	accFile.write('\n')
	accFile.write(password)
	accFile.write('\n')
	accFile.write(address)
	accFile.write('\n')
	accFile.write(marketPort)
	accFile.write('\n')
	accFile.close()


	
	

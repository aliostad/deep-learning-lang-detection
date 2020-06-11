#==============================================================================
# doc_test.py
# Python script that tests API for doc purposes.  
#==============================================================================
## Tested with python 2.7
##
## Copyright (c) 2012, Exosite LLC
## All rights reserved.
##
## For License see LICENSE file

import sys
import socket #needed for the GetRIDfromCIK() function below - TODO: remove and just use RID 
import json   #needed for the GetRIDfromCIK() function below - TODO: remove and just use RID 

from provision_device import ProvisionDevice
from provision_manager import ProvisionManager

HOST = 'm2.exosite.com'
PORT = 80
VENDOR_NAME = 'ENTERVENDORNAME'            # This is from your portals instnace on the page /admin/provision
VENDOR_TOKEN = 'ENTERVENDORTOKEN'          # This is from your portals instnace on the page /admin/provision
CLONE_RID =  'ENTERCLONERID'               # In a Portal in the VENDOR hierarchy, create a device (client) and check the box "Use as Clone" and copy the RID here  
DEVICE_OWNER_CIK = 'ENTERPORTALCIK'        # This can any client in the hierarchy under VENDOR (TODO: remove and just use RID )
DEVICE_MODEL = 'MODELNAMEHERE'             # This can be anything as long as it is unique for the VENDOR
FIRST_SERIAL_NUM = '9001'                  # Arbitrary number 1
SECOND_SERIAL_NUM = '1999'                 # Arbitrary number 2
CONTENT_ID = 'FIRMWARENAME'                # This can be anything as long as it is unique for the MODEL

#===============================================================================   
def main():
  
  #instantiate our device class
  device = ProvisionDevice(HOST, PORT, VENDOR_NAME, DEVICE_MODEL, CONTENT_ID)
  DEVICE_OWNER_RID = GetRIDfromCIK(DEVICE_OWNER_CIK) #NOTE - should just set the RID here - TODO: remove and just use RID   
  
  #instantiate our manager class
  manager = ProvisionManager(HOST, PORT, VENDOR_TOKEN, DEVICE_MODEL, CLONE_RID, CONTENT_ID)
  
  #create a new model entry (/provision/manage/model/ POST)
  manager.provisionManageModelPOST()
  
  #list models belonging to vendor (/provision/manage/model/ GET)
  print manager.provisionManageModelGET()
  
  #update model information (/provision/manage/model/<model> PUT)
  manager.provisionManageModelModelPUT('&options=nohistorical')
  
  #show information about a model (/provision/manage/model/<model> GET)
  print manager.provisionManageModelModelGET()

  #create content bucket for model (/provision/manage/content/<model> POST)
  manager.provisionManageContentModelPOST()
  
  #list all content available for model (/provision/manage/content/<model> GET)
  print manager.provisionManageContentModelGET()
  
  #upload content for model (/provision/manage/content/<model>/<id> POST)  
  manager.provisionManageContentModelIDPOST()
  
  #show information about content (/provision/manage/content/<model>/<id> GET)
  print manager.provisionManageContentModelIDGET()
  
  #download content (/provision/manage/content/<model>/<id> GET with download=true)
  print manager.provisionManageContentModelIDGET('download=true')
  
  #add serial numbers to a model (/provision/manage/model/<model>/ POST)
  manager.provisionManageModelModelInfoPOST('add=true&sn=' + FIRST_SERIAL_NUM)
  manager.provisionManageModelModelInfoPOST('add=true&sn=' + SECOND_SERIAL_NUM)
  
  #list serial numbers associated with model (/provision/manage/model/<model>/ GET)
  print manager.provisionManageModelModelInfoGET()
  
  #instantiate a client and map to serial number (/provision/manage/model/<model>/<sn> POST)
  manager.provisionManageModelModelSNPOST(FIRST_SERIAL_NUM, 'enable=true&owner=' + DEVICE_OWNER_RID)
  
  #move a client to a new serial number (/provision/manage/model/<model>/<sn> POST with oldsn)
  manager.provisionManageModelModelSNPOST(SECOND_SERIAL_NUM, 'enable=true&oldsn=' + FIRST_SERIAL_NUM)
  
  #show specific serial number status (/provision/manage/model/<model>/<sn> GET)    
  print manager.provisionManageModelModelSNGET(SECOND_SERIAL_NUM)

  #grab server ip (/ip GET)
  device.ip();
  
  #activate device (/provision/activate POST)
  device.provisionActivatePOST(SECOND_SERIAL_NUM);
  
  #regenerate a client's CIK and re-enable for activation (/provision/manage/model/<model>/<sn> POST with enable)
  manager.provisionManageModelModelSNPOST(SECOND_SERIAL_NUM, 'enable=true')
  
  #activate device again (/provision/activate POST)
  device.provisionActivatePOST(SECOND_SERIAL_NUM);
  
  #show specific serial number activation log (/provision/manage/model/<model>/<sn> GET with show=log)
  print manager.provisionManageModelModelSNGET(SECOND_SERIAL_NUM, 'show=log')
  
  #get content info (/provision/download GET with info)
  print device.provisionDownloadGET('&info=true')
  
  #download content (/provision/download GET)
  print device.provisionDownloadGET()
  
  #disable a CIK associated with serial number (/provision/manage/model/<model>/<sn> POST with disable)
  manager.provisionManageModelModelSNPOST(SECOND_SERIAL_NUM, 'disable=true')
  
  #show specific serial number status (/provision/manage/model/<model>/<sn> GET)
  print manager.provisionManageModelModelSNGET(SECOND_SERIAL_NUM)
  
  #delete a serial number (/provision/manage/model/<model>/<sn> DELETE)
  manager.provisionManageModelModelSNDELETE(FIRST_SERIAL_NUM)
  manager.provisionManageModelModelSNDELETE(SECOND_SERIAL_NUM)
  
  #remove content from model (/provision/manage/content/<model>/<id> DELETE)
  manager.provisionManageContentModelIDDELETE()

  #list all content available for model (/provision/manage/content/<model> GET)
  print manager.provisionManageContentModelGET()
  
  #delete a model from vendor (/provision/manage/model/<model DELETE> 
  manager.provisionManageModelModelDELETE()

  #list models belonging to vendor (/provision/manage/model/ GET)
  print manager.provisionManageModelGET()
  
  del device
  del manager
  
#===============================================================================   
#TODO: remove and just use RID 
def GetRIDfromCIK(cik):
  ARGUMENTS = ["alias",'']
  PROCEDURE = "lookup"
  CALLREQUEST1 = {"id" : 1, "procedure":PROCEDURE, "arguments":ARGUMENTS}
  CALLS = [CALLREQUEST1]
  AUTH = { "cik" : cik }
  RPC = { "auth" : AUTH, "calls":CALLS}

  json_rpc = json.dumps(RPC)

  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  s.connect((HOST, PORT))
  s.send('POST /onep:v1/rpc/process HTTP/1.1\r\n')
  s.send('Host: m2.exosite.com\r\n')
  s.send('Content-Type: application/json; charset=utf-8\r\n')
  body = json_rpc
  s.send('Content-Length: '+ str(len(body)) +'\r\n\r\n')
  s.send(body)

  data = s.recv(1024)
  s.close()
  jsonrid = json.loads(getbody(data))
  return jsonrid[0]['result']  
   
#=============================================================================== 
#TODO: remove and just use RID 
def getbody(rxdata):
  line = rxdata.find('\r\n') #end of HTTP line
  if (-1 != line):
    line = rxdata[line:].find('\r\n') #end of Date line
    if (-1 != line):
      line = rxdata[line:].find('\r\n') #end of Server line
      if (-1 != line):
        line = rxdata[line:].find('\r\n') #end of Connection line
        if (-1 != line):
          line = rxdata[line:].find('\r\n\r\n') #end of Content line (beginning of body)
          if (-1 != line):
            return rxdata[line+4:]
  return -1  
   
#===============================================================================        
if __name__ == '__main__':
  sys.exit(main())


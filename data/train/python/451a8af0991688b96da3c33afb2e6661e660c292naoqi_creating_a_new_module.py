"""
  This script shows how to create a NaoQi module written in Python
"""

import sys,os

NAO_IP = "127.0.0.1" #  <---- Enter here your Robot IP Adress
NAO_PORT = 9559

# Check AL_DIR:
path = `os.environ.get("AL_DIR")`
home = `os.environ.get("HOME")`

if path == "None":
        print "the environnement variable AL_DIR is not set, aborting..."
        sys.exit(1)
else:
# import naoqi lib
        alPath = path + "/extern/python/aldebaran"
        alPath = alPath.replace("~", home)
        alPath = alPath.replace("'", "")
        sys.path.append(alPath)
        import naoqi
        from naoqi import ALBroker
        from naoqi import ALModule
        from naoqi import ALProxy
        from naoqi import ALBehavior

#____________
# Definition of our new module:


class MyModulePython(ALModule):
  def printSomething(self,myString ):
    "A method that just print on screen what is sent, and also calls ALLogger"
    
    #Print what was sent:
    print "Printing something: " + myString

    # Create proxy to ALLogger and logs a debug message:
    try:
      loggerProxy = ALProxy("ALLogger")
      loggerProxy.debug("MyModulePython","printSomething called with:" + myString )
    except:
      print "Unable to create proxy to ALLogger"


#____________
# Creation of a new Python Broker

# Information concerning our new python broker
ThisBrokerIP = "127.0.0.1"
ThisBrokerPort = BPORT

# Creating it 
try:
  pythonBroker = ALBroker("pythonBroker",ThisBrokerIP,ThisBrokerPort, NAO_IP, NAO_PORT)
except RuntimeError,e:
  print("Could not connect to NaoQi's main broker")
  exit(1)


#___________
# Create new module:


newMyModulePythonInstance = MyModulePython("modulePython")


# Calling module services (could be made from another module, via a proxy)

newMyModulePythonInstance.printSomething("Hello, world")


# Shut down the Python Broker
try:
  pythonBroker.shutdown()
except RuntimeError,e:
  print("Could not shut down Python Broker")
  exit(1)


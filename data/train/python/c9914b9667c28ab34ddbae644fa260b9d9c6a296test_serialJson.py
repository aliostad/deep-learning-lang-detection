from Devices import *

__author__ = 'tic'


york = AirConditioner(mode='normal', temp='24', fan='auto', sweep='off')

nec = DatashowNEC();
nec.powerOn()

print york.getCode()
print york.getJsonCode()
print
print york.info()
print
print nec.getJsonCode()

controller = ControllerDeviceCOMJson(york,'/dev/ttyACM0',9600)
controllerNEC = ControllerDeviceCOMJson(nec,'/dev/ttyACM0',9600)


time.sleep(3)

york.status = 'off'
#controller.execute()
controllerNEC.execute()

time.sleep(10)

nec.powerOff()
controllerNEC.execute()
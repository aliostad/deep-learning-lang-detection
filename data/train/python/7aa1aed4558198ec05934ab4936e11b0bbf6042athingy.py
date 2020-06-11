from commclass import Controller
import time
import serial
import math

serialPort = "/dev/ttyACM0"
controller = Controller(serialPort, 9600, 1)

def setDistance(maximum, minimum):
    controller.getSensor(2)
    current = controller.currentSensor

    if current < minimum:
        print("Going Toward!" + str(current))
        while current < minimum:
            print("Distance: " + str(current))
            controller.getSensor(2)
            current = controller.currentSensor
            controller.writeSteerPacket('S', 0, 0, 0, 0)
            controller.writeDrivePacket('D', 130, 130, 'F', 'F')
            
            
    elif current > maximum:
        print("Going Away!" + str(current))
        while current > maximum:
            print("Distance: " + str(current))
            controller.getSensor(2)
            current = controller.currentSensor
            controller.writeSteerPacket('S', 0, 0, 0, 0)
            controller.writeDrivePacket('D', 130, 130, 'R', 'R')
            
    
    controller.writeDrivePacket('D', 0, 0, 'F', 'F')
    controller.writeSteerPacket('S', 90, 90, 90, 90)

try:
    if controller.connected:
        print("Controller Connected!")
        time.sleep(5)
    else:
        print("Controller Failed to Connect!")
        raise KeyboardInterrupt

    while True:
        print("Setting Distance 0")
        setDistance(250, 200)
        time.sleep(5)
    
        print("Setting Distance 1")
        setDistance(1150, 1100)
        time.sleep(5)

        print("Setting Dristance 2")
        setDistance(2000, 1900)
        time.sleep(5)

except KeyboardInterrupt:
    controller.writeDrivePacket('D', 0, 0, 'F', 'F')
    controller.writeSteerPacket('S', 90, 90, 90, 90)
    controller.close()
    print("Serial Port Closed!")

from commclass import Controller
import time
import serial
import math

serialPort = "/dev/ttyACM0"
controller = Controller(serialPort, 9600, 1)
sensors = [0, 0, 0, 0]
angle = 0
parallel = 0
distance = 0

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
            controller.writeDrivePacket('D', 130, 130, 'R', 'R')
            
            
    elif current > maximum:
        print("Going Away!" + str(current))
        while current > maximum:
            print("Distance: " + str(current))
            controller.getSensor(2)
            current = controller.currentSensor
            controller.writeSteerPacket('S', 0, 0, 0, 0)
            controller.writeDrivePacket('D', 130, 130, 'F', 'F')
            
    
    controller.writeDrivePacket('D', 0, 0, 'F', 'F')
    controller.writeSteerPacket('S', 90, 90, 90, 90)

def getParallel():
    print("Gettin' Parallel!")
    parallel = 0
    while parallel == 0:
        controller.getSensor(2)
        sensors[0] = controller.currentSensor
        controller.getSensor(3)
        sensors[1] = controller.currentSensor
        angle = math.atan2((sensors[0]-sensors[1]), 480)

        if angle < -0.05:
            controller.writeSteerPacket('S', 45, 135, 45, 135)
            controller.writeDrivePacket('D', 255, 255, 'R', 'F')

        elif angle > 0.05:
            controller.writeSteerPacket('S', 45, 135, 45, 135)
            controller.writeDrivePacket('D', 255, 255, 'F', 'R')
                         

        else:
            controller.writeSteerPacket('S', 90, 90, 90, 90)
            controller.writeDrivePacket('D', 0, 0, 'F', 'F')
            parallel = 1
            return parallel
            
def driveTime(speed, direction, duration):
    controller.writeDrivePacket('D', speed, speed, direction, direction)
    time.sleep(duration)
    controller.writeDrivePacket('D', 0, 0, 'F', 'F')


def checkWall():
    controller.getSensor(2)
    rearSensor = controller.currentSensor
    controller.getSensor(3)
    frontSensor = controller.currentSensor

    if (frontSensor-500)>rearSensor:
        print (str(frontSensor-500) + " " + str(rearSensor))
        return 'R'
    elif (rearSensor-500)>frontSensor:
        print (str(rearSensor-500) + " " + str(frontSensor))
        return 'F'
    else:
        return 'N'

try:
    if controller.connected:
        print("Controller Connected!")
        time.sleep(5)
    else:
        print("Controller Failed to Connect!")
        raise KeyboardInterrupt
    direction = 'F'
    checkDirection = 'N'

    print("Setting Distance")
    setDistance(1500, 1000)
    print("Getting Parallel")
    getParallel()
    


    while True:
        driveTime(130, 'R', 3)
        setDistance(1500, 1000)
        getParallel()
        print("Do it again!")



        


except KeyboardInterrupt:
    controller.writeDrivePacket('D', 0, 0, 'F', 'F')
    controller.writeSteerPacket('S', 90, 90, 90, 90)
    controller.close()
    print("Serial Port Closed!")

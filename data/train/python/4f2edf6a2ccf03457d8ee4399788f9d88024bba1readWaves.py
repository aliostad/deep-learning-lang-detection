from commclass import Controller
import matplotlib.pyplot as plt
import time
import math

serialPort = "/dev/ttyACM0"
controller = Controller(serialPort, 9600, 1)
sensor1 = [0, 0]
sensor2 = [0, 0]
count = [0, 0]
timeOn = 0
sensors = [0, 0]

out = open('SensorOutput', 'w')
try:
    if controller.connected:
        print ("Connected")
        time.sleep(2)
    else:
        print ("Failed to Connect")
        raise KeyboardInterrupt

    controller.writeSteerPacket('S', 90, 90, 90, 90)
    controller.writeDrivePacket('D', 255, 255, 'R', 'R')
    
    while True:
        controller.getSensor(2)
        sensors[0] = controller.currentSensor
        sensor1.append(controller.currentSensor)
        print("One: " + str(controller.currentSensor))
        controller.getSensor(3)
        sensors[1] = controller.currentSensor
        sensor2.append(controller.currentSensor)
        print("Two: " + str(controller.currentSensor))
        timeOn += 0.1
        count.append(timeOn)
        print("Time: "+ str(timeOn))
        time.sleep(0.1)
        out.write(str(sensors[0]) + ',' + str(sensors[1]) + ',' + str(timeOn) + '\n')



except KeyboardInterrupt:
    print("Closing")
    controller.writeDrivePacket('D', 0, 0, 'F', 'F')
    out.close()
    plt.plot(count, sensor1, count, sensor2)
    plt.show()
    controller.close()

import sys
import mosquitto
import pexpect
import socket
import struct
import threading

#For mqtt
broker="localhost" 
port=1883
sensor="tempdetector"
topic="temperature"
HOST = ''
PORT = 8888 



#Thread number one which is suppose to send to the broker the value of the ino sketch
def sendValueToGalileoBroker(mqttc):
	tempbool = False;
	
	p = pexpect.spawn("sh",["/etc/init.d/clloader.sh"],timeout=None,logfile=None)
	line = p.readline()
	#line = p.readline()
	#show that the sh has been launched
	print "sh has been launched "+line
	while line:
                print line
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		s.connect((HOST, PORT))
                print "let's goooo trueee"
		while True:
			#receive "Temp"	
			data = s.recv(32)
			str = data.split(' ')
			print data
			#mqttc.publish(topic,str[2])
			if tempbool :
				print "allume LED"
				s.send('H')
				tempbool=False
			else : 
				print "extinction LED"
				s.send('L')
				tempbool=True


#Thread number two which is suppose watching the action from the openhab
def listenMessageFromCentralBroker(mqttc):
    print "LOADDD"
	



if __name__ == "__main__":
    mqttc = mosquitto.Mosquitto(sensor)
    #connect to broker
    mqttc.connect(broker,port,60)
    a = threading.Thread(None, listenMessageFromCentralBroker, None, (mqttc,), {}) 
    b = threading.Thread(None, sendValueToGalileoBroker, None, (mqttc,), {}) 
    a.start() 
    b.start()
                                                                                                                                                                           
import paho.mqtt.publish as publish
import datetime
import time
import random


#broker = "192.168.2.69"
broker = "192.168.1.30"
clientId="Silmak/"+str(random.randint(1000,9999))

while True:
    now = datetime.datetime.now() 
    hora = now.strftime("%Y-%m-%d %H:%M:%S")
    
    print broker + " | " + clientId + " | " + hora

    publish.single("temp/client/1", random.randint(10,20), hostname = broker, client_id= clientId, will=None, auth=None, tls=None)
    publish.single("time/client/1", hora, hostname = broker)
    

    time.sleep(2)

import paho.mqtt.client as mqtt
import time

BROKER_PORT = 1883
BROKER_HOST = "test.mosquitto.org" # Test host from mosquitto.org
KEEPALIVE = 60 #maximum period in seconds allowed between communication
TOPIC='tk/demo'

def on_connect(client,userdata,results):
    print "Connected with result "+str(results)
    client.subscribe(TOPIC,0) # subscribe to broker with topic
    
    
def on_publish(client,userdata,mid):
    print "Message has been published with id = "+str(mid)

def on_message(client,userdata,msg):
    print "Incomming message is "+msg.topic +":"+msg.payload
    
            
client = mqtt.Client()
    
# Be generated when client receives CONNACK message from broker.
client.on_connect =  on_connect

# Be generated after client has published message to broker.
client.on_publish = on_publish

# Be generated after message from broker arrived.
client.on_message = on_message

client.connect(BROKER_HOST,BROKER_PORT,KEEPALIVE)
client.loop_start()

while True:
    try :
        time.sleep(5) #option, do not need
        client.publish(TOPIC,"Hello")
    except KeyboardInterrupt :
        client.unsubscribe(TOPIC)
        client.disconnect()
        break

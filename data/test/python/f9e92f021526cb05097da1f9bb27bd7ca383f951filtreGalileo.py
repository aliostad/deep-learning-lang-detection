import mosquitto, time


#############################
#### Broker ServeurMqtt######
#############################

brokerServeur ="169.254.129.145"
portServeur = 1883
topicServeur ="sensor"

nameMosquitto = "Serveur"


mqttcServeur = mosquitto.Mosquitto(nameMosquitto)
mqttcServeur.connect(brokerServeur, portServeur, 60)

#############################
####  Broker   Galileo ######
#############################

brokerGalileo="localhost"
portGalileo = 1883
topicGalileo ="sensor"

nameMosquitto = "Galileo"

#On receipt of a message resend it to the broker of the server
def on_message(mosq, obj, msg):
	mqttcServeur.publish(msg.topic ,msg.payload )


mqttcGalileo = mosquitto.Mosquitto(nameMosquitto)
mqttcGalileo.connect(brokerGalileo, portGalileo, 60)

mqttcGalileo.subscribe(topicGalileo,0)

#define the callbacks
mqttcGalileo.on_message = on_message

#Number of millised mqttcGalileo is waiting
TimeMs = 15;
while True:
   	mqttcGalileo.loop(TimeMs)







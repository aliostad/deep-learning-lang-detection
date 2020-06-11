import os
import time
from kafka import SimpleProducer, KafkaClient
from kafka.common import LeaderNotAvailableError
import logging

logging.basicConfig()
logger = logging.getLogger('kafka-app')

# IP:PORT of a Kafka broker. The typical port is 9092.
KAFKA_BROKER_IP_PORT = os.getenv('KAFKA_BROKER', '192.168.86.10:9092')
print "KAFKA BROKER: " + KAFKA_BROKER_IP_PORT
kafka = KafkaClient(KAFKA_BROKER_IP_PORT)
producer = SimpleProducer(kafka)

# Note that the application is responsible for encoding messages to type str
while True:
	print('Sending...')
	logger.info('Sending...')
	try:
		producer.send_messages("test-topic", "The medium is the message.")
	except LeaderNotAvailableError:
		logger.warning('Caught a LeaderNotAvailableError. This seems to happen when auto-creating a new topic.')
		print('Caught a LeaderNotAvailableError. This seems to happen when auto-creating a new topic.')
	time.sleep(3)

# kafka.close()
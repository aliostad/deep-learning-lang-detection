import logging
from kafka.client import KafkaClient
from kafka.producer import SimpleProducer
from kafka.common import LeaderNotAvailableError,KafkaUnavailableError

log = logging.getLogger("kafka")


class FeedProducer():
    """
    Feed Producer class
    use send() to send to any topic
    """
    
    def __init__(self, broker):
        try:
            self.client = KafkaClient(broker)
            self.prod = SimpleProducer(self.client)
        except KafkaUnavailableError:
            log.critical( "\nCluster Unavailable %s : Check broker string\n", broker)
            raise
        except:
            raise
    
    def send(self, topic, *msgs):
        try:
            self.prod.send_messages(topic, *msgs)
        except LeaderNotAvailableError:
            self.client.ensure_topic_exists(topic)
            return self.send(topic, *msgs)
        except:
            raise

import yaml

class Configuration:

    def __init__(self,filename):
        with open(filename, 'r') as f:
            self.doc = yaml.load(f)
        
    # parse server details
    def getMySQLDetails(self):
        server = self.doc["server"]
        host = server[0]['host']
        username = server[1]['username']
        password = server[2]['password']
        dbName = server[3]['dbName']

        return host,username,password,dbName

    # parse kafka broker
    def getBrokerDetails(self):
        broker = self.doc["broker"]
        host = broker[0]['host']
        port = broker[1]['port']

        return host,port
    
    # parse consumer details
    def getConsumerDetails(self):
        consumer = self.doc["consumer"]
        topic = consumer[0]['topic']
        consumergroup = consumer[1]['consumergroup']

        return topic,consumergroup

    # parse avro schema
    def getAvroSchema(self):
        avro = self.doc["avro"]
        schema = avro[0]['schema']
        
        return schema
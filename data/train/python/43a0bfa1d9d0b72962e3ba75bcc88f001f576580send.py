from net.es.enos.rabbitmq import CreateToken
from net.es.enos.rabbitmq import BrokerInfo
from net.es.enos.rabbitmq import UUIDManager
from net.es.enos.rabbitmq import SSLConnection
from net.es.enos.rabbitmq import ParseMessage

from org.python.core.util import StringUtil

#
# Created by davidhua on 7/3/14.
#

broker = BrokerInfo()
broker.setHost("localhost")
broker.setUser("david2")
broker.setPassword("123")
broker.setPort(5672) # 5671 for ssl
broker.setSSL(False) # True for ssl

QUEUE_FILE = "/var/netshell/users/admin"
messages = []
actualMessage = []

# Find name of consumer queue
uuidQueue = UUIDManager(QUEUE_FILE)
queueName = uuidQueue.checkUUID()

# Create connection (doesn't have to be a ssl one, despite the name)
factory = SSLConnection(broker).createConnection()
connection = factory.newConnection()
channel = connection.createChannel()

# Get token from consumer
tokenGetter = CreateToken(broker, channel, queueName)
token = tokenGetter.getToken()

# Attach token to message
message = token + ":"
messages = messages+[message]

for arg in command_args[2:]:
    messages = messages  + [str(arg)]

parsedMessage = ParseMessage(messages)
sendMessage = parsedMessage.getMessage()

channel.queueDeclare(queueName, False, False, True, None)
channel.basicPublish("", queueName, None, StringUtil.toBytes(str(sendMessage)))
print (" [x] Sent " + sendMessage )

channel.close()
connection.close()





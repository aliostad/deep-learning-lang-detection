from blacklist.common.config		import Config
from blacklist.common.encryption	import Encryption

import datetime
import time
import random
import zmq

class Broker:
	def __init__(self):
		self.config = Config()
		self.context = zmq.Context()
		self.broker = self.context.socket(zmq.REQ)
		self.broker.connect(self.config["blacklist.broker"])
		self.encryption = Encryption(self.config["blacklist.api.psk"])

	def request_dispatcher(self, action):
		data = {
			"username":	self.config["username"],
			"password":	self.config["password"],
			"random":	random.random()*time.mktime(datetime.datetime.timetuple(datetime.datetime.now()))
		}

		data["action"] = action
		self.broker.send(self.encryption.encrypt(data))
		return self.encryption.decrypt(self.broker.recv())

	def update_listings(self):
		return self.request_dispatcher("update_listings")

	def update_whitelistings(self):
		return self.request_dispatcher("update_whitelistings")

	def update_rules(self):
		return self.request_dispatcher("update_rules")

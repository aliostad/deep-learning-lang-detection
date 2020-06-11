#!/usr/bin/python
from stem.control import Controller
from os import getenv
from re import match

PORT = getenv('TORCONTROL')

try:
	controller = Controller.from_socket_file(path=PORT)
except:
	try:
		controller = Controller.from_port(port=int(PORT))
	except:
		try:
			controller = Controller.from_port(address=PORT)
		except:
			if not PORT:
				print 'Failed to connect to TORCONTROL=%s' % PORT
				raise SystemExit(1)
			res = match('([^/:]*):([0-9]*)$', PORT).groups()
			if res[0]:
				if res[1]:
					controller = Controller.from_port(address=res[0],port=int(res[1]))
				else:
					controller = Controller.from_port(address=res[0])
			else:
				controller = Controller.from_port(port=int(res[1]))
	
controller.authenticate()

if __name__ == '__main__':
	print 'Tor %s' % controller.get_version()
	print 'Socks %s' % controller.get_socks_listeners()
	#print 'Exit %s' % controller.get_exit_policy()

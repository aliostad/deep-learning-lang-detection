
from Client import *
from Broker import *

__version__ = '1.0'

def broker(broker_ip, broker_port):
	b = Broker(broker_ip, broker_port)


def client(args):
	c = Client(args.brokerhost, args.port, args.username, args.password)


def parsing():
	"""generate and return a parser from the command line"""

	parser = argparse.ArgumentParser(prog='HolePunching', 
        description='NAT traversal programm in Python. '\
        'Several clients are behind a firewall '\
        'and they want to communicate directly between them. '\
        'Broker is accessible since the outside and it initializes '\
        'the direct connection between clients ')
	parser.add_argument('--version', action='version',
		version='%(prog)s ' + __version__)

	subparsers = parser.add_subparsers()

	# Broker Mode
	brokerparser = subparsers.add_parser('broker',
		help='Broker mode')
	brokerparser.set_defaults(mode='broker')
	brokerparser.add_argument('host', default='127.0.0.1', help='IP address to listen on')
	brokerparser.add_argument('port', type = int, 
		default = 4242, help='Port to listen on.')
		
	# Client mode
	clientparser = subparsers.add_parser('client',
		help='Client mode')
	clientparser.set_defaults(mode='client')
	clientparser.add_argument('brokerhost', 
		help="Broker's address to connect")
	clientparser.add_argument('port', type = int,
		help="Broker's port to connect")
	clientparser.add_argument('username')
	clientparser.add_argument('password')

	return parser

def main():
	parser = parsing()
	args = parser.parse_args()
	#broker mode
	if args.mode == 'broker':
		broker(args.host, int(args.port))
	#client mode
	elif args.mode == 'client':
		client(args)
	else:
		sys.exit(args.mode+' does not exist')

if __name__ == '__main__':
    main()

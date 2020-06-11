from chat.clients.app_client import AppClient


class TelnetClient(AppClient):

	routes = {
		'login': 			{ 'controller':'UsersController', 'method':'login', 'args': ['username','password'] },
		'logout': 		{ 'controller':'UsersController', 'method':'logout' },
		'register': 	{ 'controller':'UsersController', 'method':'register', 'args': ['username','password','email'] },
		'whoami': 		{ 'controller':'UsersController', 'method':'whoami' },
		'protocol': 	{ 'controller':'UsersController', 'method':'protocol', 'args':['type'] },
		'token': 			{ 'controller':'UsersController', 'method':'token' },
		'quit': 			{ 'controller':'UsersController', 'method':'quit' },
		'set': 			  { 'controller':'UsersController', 'method':'set', 'args': ['field','value*'] },
		'profile': 		{ 'controller':'UsersController', 'method':'profile', 'args': ['field'] },
		'joined': 		{ 'controller':'UsersController', 'method':'joined' },
		'following': 	{ 'controller':'UsersController', 'method':'following' },
		'session': 		{ 'controller':'UsersController', 'method':'session' },
		'sessions': 	{ 'controller':'UsersController', 'method':'sessions_all' },
		'forgotten': 	{ 'controller':'UsersController', 'method':'forgotten', 'args':['username'] },
		'reset': 			{ 'controller':'UsersController', 'method':'reset', 'args':['reset_token','new_password'] },
		'status': 		{ 'controller':'UsersController', 'method':'status', 'args':['value'] },

		'list': 			{ 'controller':'ChannelsController', 'method':'list' },
		'search': 		{ 'controller':'ChannelsController', 'method':'search', 'args':['keywords'] },
		'info': 			{ 'controller':'ChannelsController', 'method':'info', 'args':['name'] },
		'create': 		{ 'controller':'ChannelsController', 'method':'create', 'args': [ 'name' ] },
		'join': 			{ 'controller':'ChannelsController', 'method':'join', 'args':['name'] },
		'part': 			{ 'controller':'ChannelsController', 'method':'part', 'args':['name'] },
		'follow': 		{ 'controller':'ChannelsController', 'method':'follow', 'args':['name'] },
		'unfollow': 	{ 'controller':'ChannelsController', 'method':'unfollow', 'args':['name'] },
		'mode': 			{ 'controller':'ChannelsController', 'method':'mode', 'args': ['name','field','value'] },
		'invite': 		{ 'controller':'ChannelsController', 'method':'invite', 'args':['name','username'] },
		'ban': 				{ 'controller':'ChannelsController', 'method':'ban', 'args':['name', 'username'] },
		'unban': 			{ 'controller':'ChannelsController', 'method':'unban', 'args':['name', 'username'] },
		'admins': 		{ 'controller':'ChannelsController', 'method':'admins', 'args':['name'] },
		'admin_add': 		{ 'controller':'ChannelsController', 'method':'admins_add', 'args':['name','username'] },
		'admin_remove': { 'controller':'ChannelsController', 'method':'admins_remove', 'args':['name','username'] },

		'post': 			{ 'controller':'PostsController', 'method':'add', 'args':['channel','data*'] },
		'like': 			{ 'controller':'PostsController', 'method':'like', 'args':['post_id'] },
		'report': 		{ 'controller':'PostsController', 'method':'report', 'args':['post_id'] },
		
		'quit': 			{ 'controller':'UsersController', 'method':'quit' },
		'whois': 			{ 'controller':'UsersController', 'method':'whois', 'args':['username'] },
		'kick': 			{ 'controller':'ChannelsController', 'method':'kick', 'args':['channel','username'] },
		'time': 			{ 'controller':'SystemsController', 'method':'time' },

		'memory': 			{ 'controller':'SystemsController', 'method':'memory' },
		'test': 				{ 'controller':'SystemsController', 'method':'test' },
		'ping': 				{ 'controller':'SystemsController', 'method':'ping' }

		# ,
		# 'hello': { 'controller':'HelpsController', 'method':'hello' },
		# 'register': { 'controller':'UsersController', 'method':'register' },
		# 'help': { 'controller':'HelpsController', 'method':'show' }
	}

	def startup(self):
		self.set_protocol('text')

	def lineReceived(self, line):
		settings = self.parse(line)

		controller = settings['route']['controller']
		method = settings['route']['method']
		args = settings['args']

		result = self.dispatch(controller, method, args)

		if result:
			if 'code' not in result:
				result = { 'code':result, 'data':{} }
			self.send(result['code'], result['data'])


	def parse(self, input):
		#Args passed inline with no --
		split = input.lower().split()
		command = split[0]

		#Check command exists in dict
		if command not in self.routes:
			return False

		route = self.routes[command]

		#Arguments
		data = {}
		if 'args' in route:
			key = 0
			for field in route['args']:
				key += 1

				if key >= len(split):
					#args out of range, maybe not enough args passed
					#check if arg is required
					pass
				else:
					value = split[key]
					if field[-1:] == '*':
						field = field[0:-1]
						value = ' '.join(split[key:])
					data[field] = value

		return {
			'route':route,
			'args':data
		}


from controllers.helps_controller import HelpsController
from controllers.worlds_controller import WorldsController
from controllers.users_controller import UsersController


class Command:

	routes = {
		'login': { 'controller':UsersController, 'method':'login' },
		'help': { 'controller':HelpsController, 'method':'show' },
		'create world': { 'controller':WorldsController, 'method':'create' },
	}

	callback = None

	def __init__(self, Game):
		self.Game = Game
		return


	def init(self):
		return


	def run(self, request, command):
		request.send('Command: "%s"\n\r' % command)

		#Hooked callback for input?
		if self.callback:
			self.callback(command)
			self.callback = None
			return

		#Admin prefixed
		prefix = False
		args = command.split(' ')
		if args[0].lower() == 'admin':
			prefix = 'admin'
			command = ' '.join(args[1:])

		#Check command exists in dict
		if command not in self.routes:
			print('Unknown command, command not mapped')
			request.send('Unknown command')
			return

		route = self.routes[command]
		controller = route['controller'](self.Game)
		method = route['method'];

		#If admin route then change the method
		if prefix:
			method = prefix+'_'+method

		controller.requester(request)
		getattr(controller, method)()


	def hook(self, method):
		self.callback = method


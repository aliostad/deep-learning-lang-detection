ang.config(function($routeProvider){
	$routeProvider
		.when('/', {
			templateUrl : '/html/chit.html',
			controller  : 'ChitController'
		})
		.when('/chat',{
			templateUrl : '/html/chat.html',
			controller  : 'ChatController'
		})
		.when('/settings',{
			templateUrl : '/html/settings.html',
			controller  : 'SettingsController'
		})
		.when('/createRoom',{
			templateUrl : '/html/createRoom.html',
			controller  : 'CreateRoomController'
		})
		.when('/join',{
			templateUrl : '/html/join.html',
			controller  : 'JoinController'
		})
});


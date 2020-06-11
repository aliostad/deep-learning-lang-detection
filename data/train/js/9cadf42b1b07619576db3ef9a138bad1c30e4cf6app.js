var app = angular.module('minecraftApp', ['ngRoute']);

app.config (function ($routeProvider) {
	$routeProvider
		.when('/general',
			{
				controller: 'GeneralController',
				templateUrl: 'app/partials/general.html'
			})
		.when('/players',
			{
				controller: 'PlayersController',
				templateUrl: 'app/partials/players.html'
			})
		.when('/rewards',
			{
				controller: 'RewardsController',
				templateUrl: 'app/partials/rewards.html'
			})
		.when('/events',
			{
				controller: 'EventsController',
				templateUrl: 'app/partials/events.html'
			})
		.when('/forum',
			{
				controller: 'EmptyController',
				templateUrl: 'app/partials/forum.html'
			})
		.when('/structures',
			{
				controller: 'StructuresController',
				templateUrl: 'app/partials/structures.html'
			})
		.when('/map',
			{
				controller: 'MapController',
				templateUrl: 'app/partials/map.html'
			})
		.when('/statistics',
			{
				controller: 'StatisticsController',
				templateUrl: 'app/partials/statistics.html'
			})
    .otherwise(
      {
        controller: 'GeneralController',
        templateUrl: 'app/partials/general.html'
      });
});

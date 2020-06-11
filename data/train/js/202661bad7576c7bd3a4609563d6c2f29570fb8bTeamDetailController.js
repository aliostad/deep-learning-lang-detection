/**
 * Team Detail Controller.
 */
var TeamDetailController = function(team) {

    var controller = this;

    controller.team = team;

};

angular.module('bowling.entry.core')
    .controller('TeamDetailController', ['team', TeamDetailController])
    .config(['$stateProvider', function($stateProvider) {

        $stateProvider.state('bowling.league.team.detail', {
                url: '/',
                templateUrl: 'partials/entry/leagues/teams/detail.html',
                title: 'Team Detail',
                controller: 'TeamDetailController',
                controllerAs: 'teamController'
            });
    }]);

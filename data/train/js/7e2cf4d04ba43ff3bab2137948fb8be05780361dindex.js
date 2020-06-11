/**
 * Define the remote services
 */
module.exports = angular.module('loghApp.api', [])
      .constant('apiConfig', require('./ApiConfig'))
      .service('gameService', require('./GameService'))
      .service('leagueService', require('./LeagueService'))
      .service('pickService', require('./PickService'))
      .service('seasonService', require('./SeasonService'))
      .service('squadService', require('./SquadService'))
      .service('statsService', require('./StatsService'))
      .service('teamService', require('./TeamService'))
      .service('userService', require('./UserService'))
      .service('weekService', require('./WeekService'))
;

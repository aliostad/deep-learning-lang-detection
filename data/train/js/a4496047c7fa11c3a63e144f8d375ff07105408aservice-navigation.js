'use strict';

angular.module('app.services').factory('navigationService', [function () {
    return {
        urls: {
            identity: 'api/identity',
            sport: 'api/sport',
            rank: 'api/rank',
            player: 'api/player',
            match: 'api/match/:id',
            'match-join': 'api/match/join',
            'match-randomize': 'api/match/randomize',
            'match-start': 'api/match/start',
            'match-leave': 'api/match/leave',
            'match-close': 'api/match/close',
            tournament: 'api/tournament/:id',
            'tournament-join': 'api/tournament/join',
            'tournament-start': 'api/tournament/start',
            'tournament-leave': 'api/tournament/leave',
            'tournament-randomize': 'api/match/randomize',
        },
    };
    }]);
    
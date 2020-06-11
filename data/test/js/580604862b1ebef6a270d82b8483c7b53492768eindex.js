var Promise = require('bluebird');
var request = Promise.promisify(require('request'));

function APICall(url) {
    return request(url).then(function(resp) {
        try {
            return resp[1];
        } catch(e) {
            return new Error(e);
        }
    });
}

function lolapi(options) {
    api = {};

    api.key = options.key;
    api.loc = options.loc || 'na';
    api.url = 'https://na.api.pvp.net/api/lol/';
    api.region = options.region || 'na';

    api.champion = {
        get: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v1.2/champion/' + id + '?api_key=' + api.key;

            return APICall(url);
        },

        getAll: function(region) {
            region = region || api.region;

            var url = api.url + region + '/v1.2/champion?api_key=' + api.key;

            return APICall(url);
        },

        getFree: function(region) {
            region = region || api.region;

            var url = api.url + region + '/v1.2/champion?freeToPlay=true&api_key=' + api.key;

            return APICall(url);
        },
    };

    api.game = {
        recent: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v1.3/game/by-summoner/' + id + '/recent?api_key=' + api.key;

            return APICall(url);
        }
    };

    api.league = {
        getSummonerLeague: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v2.5/league/by-summoner/' + id.toString() + '?api_key=' + api.key;

            return APICall(url);
        },

        getSummoner: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v2.5/league/by-summoner/' + id.toString() + '/entry?api_key=' + api.key;

            return APICall(url);
        },

        getTeamLeague: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v2.5/league/by-team/' + id.toString() + '?api_key=' + api.key;

            return APICall(url);
        },

        getTeam: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v2.5/league/by-team/' + id.toString() + '/entry?api_key=' + api.key;

            return APICall(url);
        },

        getChallenger: function(type, region) {
            region = region || api.region;

            if (type === 'solo') {
              type = 'RANKED_SOLO_5x5';
            } else if (type === 'team3') {
              type = 'RANKED_TEAM_3x3';
            } else if (type === 'team5') {
              type = 'RANKED_TEAM_5x5';
            }

            var url = api.url + region + '/v2.5/league/challenger?type=' + type + '&api_key=' + api.key;

            return APICall(url);
        },
    };
    
    api.static = {};

    api.static = function() {
        console.log('not implemented');
    };
    
    api.status = function(region) {
        region = region || api.region;

        var url = 'http://status.leagueoflegends.com/shards/' + region;
            
        return APICall(url);
    };

    api.match = {
        info: function(id, timeline, region) {
            region = region || api.region;
            timeline = timeline || false;

            var url = api.url + region + '/v2.2/match/' + id + '?includeTimeline=' + timeline + '&api_key=' + api.key;

            return APICall(url);
        },

        history: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v2.2/matchhistory/' + id + '?api_key=' + api.key;

            return APICall(url);
        }
    };
    
    api.summoner = {
        ranked: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v1.3/stats/by-summoner/' + id + '/ranked?api_key=' + api.key;

            return APICall(url);
        },
        summary: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v1.3/stats/by-summoner/' + id + '/summary?api_key=' + api.key;

            return APICall(url);
        },
        masteries: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v1.4/summoner/' + id.toString() + '/masteries?api_key=' + api.key;

            return APICall(url);
        },
        runes: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v1.4/summoner/' + id.toString() + '/runes?api_key=' + api.key;

            return APICall(url);
        },
        findNameById: function(id, region) {
            region = region || api.region;

            var url = api.url + region + '/v1.4/summoner/' + id.toString() + '/name?api_key=' + api.key;

            return APICall(url);
        },
        findByName: function(name, region) {
            region = region || api.region;

            var url = api.url + region + '/v1.4/summoner/by-name/' + name.toString() + '?api_key=' + api.key;

            return APICall(url);
        }
    };
    
    api.team = {
        getBySummoner: function(id, region) {
            region = region || api.region;

            url = api.url + region + '/v2.4/team/by-summoner/' + id.toString() + '?api_key=' + api.key;

            return APICall(url);
        },

        get: function(id, region) {
            region = region || api.region;

            url = api.url + region + '/v2.4/team/' + id.toString() + '?api_key=' + api.key;

            return APICall(url);
        }
    };
    
    return api;
}


// var api = lolapi({
//     key: 'api-key-here',
//     loc: 'na'
// });

// api.team.get('TEAM-ab071580-225c-11e2-b2ea-782bcb4d1861')
//     .then(function(data) {
//         console.log(data);
//     })
//     .catch(function(e) {
//         console.error('', e);
//     });


module.exports = lolapi;

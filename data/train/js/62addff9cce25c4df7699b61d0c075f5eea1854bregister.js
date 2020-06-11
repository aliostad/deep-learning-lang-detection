'use strict';

var user = require('./user');
var league = require('./league');
var member = require('./member');

function RegisterService(userService, leagueService, memberService) {
  this.userService = userService;
  this.leagueService = leagueService;
  this.memberService = memberService;
}

RegisterService.prototype.create = function (email, password, name, callback) {
  var me = this;

  // todo: figure out transactions, uow?
  me.userService.create(email, password, function (error, user) {
    if (error) {
      return callback(error);
    }

    me.leagueService.create(user.id, name, function (error, league) {
      if (error) {
        return callback(error);
      }

      me.memberService.create(user.id, league.id, true, function (error, member) {
        if (error) {
          return callback(error);
        }

        callback(null, {user: user, league: league, member: member});
      });
    });
  });
};

module.exports = {
  Service: RegisterService,
  createService: function (userService, leagueService, memberService) {
    return new RegisterService(userService || user.createService(),
      leagueService || league.createService(), memberService || member.createService());
  }
};

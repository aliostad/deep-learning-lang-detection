var account = require('./api/account'),
  character = require('./api/character'),
  eve = require('./api/eve'),
  map = require('./api/map'),
  server = require('./api/server'),
  api = require('./api/api'),
  corporation = require('./api/corporation'),
  misc = require('./api/misc');

module.exports = function (config) {
  return {
    'account': account(config),
    'character': character(config),
    'eve': eve(config),
    'map': map(config),
    'server': server(config),
    'api': api(config),
    'corporation': corporation(config),
    'misc': misc(config)
  };
};
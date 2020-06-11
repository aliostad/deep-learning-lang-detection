var request = require('superagent');
var defaults = require('defaults');

var API = require('./api');
var Users = require('./users');
var Numbers = require('./numbers');
var Calls = require('./calls');
var Contacts = require('./contacts');

module.exports = Aircall;

function Aircall(apiID, apiToken) {
  if (!(this instanceof Aircall)) return new Aircall(apiID, apiToken);
  this.apiID = apiID;
  this.apiToken = apiToken;
  this.API = new API(apiID, apiToken);

  this.users = new Users(this.API);
  this.numbers = new Numbers(this.API);
  this.calls = new Calls(this.API);
  this.contacts = new Contacts(this.API);
}

Aircall.prototype.ping = function(callback) {
  this.API.get('/ping', null, callback);
};

Aircall.prototype.company = function(callback) {
  this.API.get('/company', null, callback);
};

'use strict';

var path = require('path'),
    Roles = require(path.join(__dirname, '../codes/Roles')),
    serviceServiceProviders = require(path.join(__dirname, '../services/serviceProviders'));

exports.get = function () {
  return [
    {
      url: '/serviceProviders',
      verb: 'POST',
      roles: [ Roles.ADMIN ],
      service: serviceServiceProviders.getAll
    },
    {
      url: '/serviceProvider',
      verb: 'POST',
      roles: [ Roles.ADMIN ],
      service: serviceServiceProviders.add
    }
  ];
};
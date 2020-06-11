'use strict';

describe('Service: configService', function () {
  // load the service's module
  angular.module('configService.Mock', ['agora']).
    constant('TITLE', 'test').
    constant('DESC', 'test more').
    constant('API', 'http://example.com/');

  beforeEach(module('configService.Mock'));

  // instantiate service
  var service;

  // Initialize the controller and a mock scope
  beforeEach(inject(function (configService) {
    service = configService;
  }));

  it('Should return correct config details', function () {
    expect(service.title).toBe('test');
    expect(service.desc).toBe('test more');
    expect(service.api).toBe('http://example.com/');
  });
});

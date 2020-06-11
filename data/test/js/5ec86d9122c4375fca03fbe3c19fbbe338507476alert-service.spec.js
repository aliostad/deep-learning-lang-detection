'use strict';

describe('AlertService', function(){
  beforeEach(module('gc.alertService'));

  var service;

  beforeEach(inject(function(AlertService) {
    service = AlertService;
  }));

  it('#get', function() {
    expect(service.get()).toEqual([]);
  });

  it('#success', function() {
    service.success('type');
    expect(service.get()[0]).toEqual({
      type: 'success',
      message: 'type'
    });
  });

  it('#error', function() {
    service.error('type');
    expect(service.get()[0]).toEqual({
      type: 'error',
      message: 'type'
    });
  });

  it('does not add duplicates', function() {
    service
    .success('identical')
    .success('identical')
    .success('cover over');
    expect(service.get().length).toEqual(2);
  });

});

'use strict';

describe('Service: profileService', function () {

  // load the service's module
  beforeEach(module('angularApp'));

  // instantiate service
  var profileService;
  beforeEach(inject(function (_profileService_) {
    profileService = _profileService_;
  }));

  it('should update profile', function () {
    profileService.updateProfile({
      "fname":"yahoo",
      "lname":"yahoo",
      "email":"yahoo",
      "phone":12345
    })

    expect(profileService.fname).toBe('yahoo');
  });

});

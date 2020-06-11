'use strict'
describe('Controller: Friend Invite', function() {
  beforeEach(module('grouple'));
  var $controller, controller, deferred;
  beforeEach(inject(function(_$controller_, $q) {
    $controller = _$controller_;
    deferred = $q.defer;
    controller = $controller('FriendInviteController', {});
  }));
  describe('Functions', function() {
    it('should send and toggleAddFriend set', function() {
      expect(controller.send).toBeDefined();
      expect(controller.toggleAddFriend).toBeDefined();
    }); 
  });
  describe('Variables', function() {
    it('should have post, post.user, showAddFriend instantiated', function() {
      expect(controller.post).toBeDefined();
      expect(controller.showAddFriend).toEqual(false);
    }); 
  });
});
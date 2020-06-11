angular.module('ui')
  .factory('FlashService', function(growl, NotificationService) {
    'use strict';

    return {
      success: function(message) {
        growl.success(message);
        NotificationService.push(message);
      },
      error: function(message) {
        growl.error(message);
        NotificationService.push(message);
      },
      warning: function(message) {
        growl.warning(message);
        NotificationService.push(message);
      },
      info: function(message) {
        growl.info(message);
        NotificationService.push(message);
      }
    };
  });
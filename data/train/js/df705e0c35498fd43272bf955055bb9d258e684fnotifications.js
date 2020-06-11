/*global Messenger window */

angular.module('notifications.services', [])
  .factory('notifications', 
    function () {

      Messenger.options = {
        extraClasses: 'messenger-fixed messenger-on-top messenger-on-right',
        theme: 'ice'
      };

      var notifications = {

        message : function (message, config) {
          message.showCloseButton = true;

          if (angular.isDefined(config) && angular.isObject(config)) {
            message = angular.extend(message, config);
          }

          // types : success, error, info
          new Messenger().post(message);
        },

        error : function (message, config) {
          notifications.message({message: message, type: 'error', id: 'error-message'}, config);
        },

        success : function (message, config) {
          notifications.message({message: message, type: 'success', id: 'success-message'}, config);
        },

        info: function (message, config) {
          notifications.message({message: message, type: 'info', id: 'info-message'}, config);
        }
      };

      return notifications;
    });
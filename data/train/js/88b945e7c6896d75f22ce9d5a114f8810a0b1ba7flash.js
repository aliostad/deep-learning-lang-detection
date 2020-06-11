datawire.factory('Flash', ['$rootScope', '$timeout', function($rootScope, $timeout) {
  // Message flashing.
  var currentMessage = null;

  return {
    setMessage: function(message, type) {
      currentMessage = [message, type];
      $timeout(function() {
        currentMessage = null;
      }, 4000);
    },
    getMessage: function() {
      if (currentMessage) {
        return currentMessage[0];
      }
    },
    getType: function() {
      if (currentMessage) {
        return currentMessage[1];
      }
    }
  };
}]);

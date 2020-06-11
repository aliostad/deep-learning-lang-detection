(function () {
"use strict";

angular.module('common')
.service('SignUpService', SignUpService);

SignUpService.$inject = ['$http', 'ApiPath'];
function SignUpService($http, ApiPath) {
  var service = this;

  service.userInfo = {};
  service.signedUp = false;

  service.signUp = function(category) {
    var config = {};
    if (category) {
      config.params = {'category': category};
    }

    //return $http.get(ApiPath + '/menu_items.json', config);
    return $http.get(ApiPath + '/menu_items/' + category + '.json');
  };

  service.saveUserInfo = function(userInfo) {
    service.signedUp = true;
    service.userInfo = userInfo;
    return true;
  };

  service.getSignUpStatus = function() {
    return service.signedUp;
  };

  service.getMyInfo = function() {
    return service.userInfo;
  }
}

})();

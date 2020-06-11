
define(function (require) {
   
  var angular = require('angular'),
      Controllers = angular.module('controllers', ['ui.bootstrap']);
   
  Controllers.controller('angEmpController', require('controllers/angEmployeeController'));
  Controllers.controller('userController', require('controllers/userController'));
  Controllers.controller('authController', require('controllers/authController'));
  Controllers.controller('mybibleController', require('controllers/mybibleController'));
  Controllers.controller('groupController', require('controllers/groupController'));
  Controllers.controller('modalGroupEditController', require('controllers/modalGroupEditController'));
  Controllers.controller('modalGroupDeleteController', require('controllers/modalGroupDeleteController'));
  Controllers.controller('questionController', require('controllers/questionController'));
  Controllers.controller('modalQuestionEditController', require('controllers/modalQuestionEditController'));
  Controllers.controller('modalQuestionDeleteController', require('controllers/modalQuestionDeleteController'));
   
   //my bible panel
   Controllers.controller('mybibleround1Controller', require('controllers/mybibleround1Controller'));
   Controllers.controller('mybibleround2Controller', require('controllers/mybibleround2Controller'));
   Controllers.controller('mybibleround3Controller', require('controllers/mybibleround3Controller'));
  return Controllers;
   
});
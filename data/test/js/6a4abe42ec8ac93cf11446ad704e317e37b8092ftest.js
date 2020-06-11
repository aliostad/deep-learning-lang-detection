define(function(require) {
'use strict';
require("./common/main");
require("./task/main");
require("./monitor/main");
require("./employee/main");
require("./user/main");
require("./profile/main");
require("./sys/main");
require("./task/main");
require("./card/main");

var testCommon = require("./common/test").testCommon;
var testEmployee = require("./employee/test").testEmployee;
var testUser = require("./user/test").testUser;
var testProfile = require("./profile/test").testProfile;
var testRule = require("./sys/test").testRule;
var testTask = require("./task/test").testTask;
var testTaskReport = require("./task/test").testReport;
var testCard = require("./card/test").testCard;

// GOABAL VAL
window.PATH = window.location.pathname.slice(0, window.location.pathname.lastIndexOf("/"));

var httpProvider;
// 定义模块
angular.module('ecgTestApp', ['ecgCommon', 'ecgTask', 'ecgMonitor', 'ecgEmployee', 'ecgUser', 'ecgSys', 'ecgTask', "ecgProfile", "ecgCard"])
.config(['$httpProvider', '$routeProvider', function ($httpProvider, $routeProvider) {
     httpProvider = $httpProvider;
}])
.run([        '$rootScope', '$http', 'EnumService',
              'ChiefService', 'ExpertService', 'OperatorService', 'ProfileService',
              'UserService', 'RuleService', 'ReplyConfigService', 'CardService',
              'TaskService',
      function($rootScope,   $http, EnumService,
               ChiefService,   ExpertService,   OperatorService ,  ProfileService,
               UserService, RuleService, ReplyConfigService, CardService,
               TaskService) {

    describe("App REST Test", function() {
        // 验证基础模块
        testCommon(it, EnumService);
        testProfile(
            {it: it}, 
            {httpProvider: httpProvider}, 
            {ProfileService: ProfileService, UserService: UserService}
          );
        // 验证员工模块
        //testEmployee(it, ChiefService, ExpertService, OperatorService, ProfileService);
        testEmployee(
          {it: it}, 
          {httpProvider: httpProvider}, 
          {ChiefService: ChiefService, ExpertService: ExpertService, OperatorService: OperatorService, ProfileService: ProfileService}
        );
        // 验证用户模块
        testUser(
          {it: it}, 
          {httpProvider: httpProvider}, 
          {UserService: UserService}
        );
        // 验证规则及回复模块
        testRule(
          {it: it}, 
          {httpProvider: httpProvider}, 
          {RuleService: RuleService, ReplyConfigService: ReplyConfigService, UserService: UserService}
        );
        // 充值模块
        testCard(
          {it: it}, 
          {httpProvider: httpProvider},
          {ProfileService: ProfileService, CardService: CardService, UserService: UserService}
        );
        // 验证任务模块
        testTask(
          {it: it}, 
          {httpProvider: httpProvider},
          {ProfileService: ProfileService, TaskService: TaskService, OperatorService: OperatorService, UserService: UserService}
        );
        // 验证任务统计模块
        testTaskReport(
          {it: it}, 
          {httpProvider: httpProvider},
          {ProfileService: ProfileService, TaskService: TaskService, OperatorService: OperatorService, UserService: UserService}
        )
    });
    mocha.run();
}]);

angular.bootstrap(document, ["ecgTestApp"]);


});

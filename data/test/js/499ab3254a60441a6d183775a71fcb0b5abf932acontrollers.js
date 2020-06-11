var phonecatControllers = angular.module('phonecatControllers', ['templateservicemod', 'navigationservice', 'mainnavigationservice']);

phonecatControllers.controller('about', ['$scope', 'TemplateService', 'NavigationService', 'MainNavigationService',
  function ($scope, TemplateService, NavigationService, MainNavigationService) {
        $scope.template = TemplateService;      
        $scope.menutitle = NavigationService.makeactive("About");
        TemplateService.title = $scope.menutitle;
        TemplateService.content = "views/about.html";
        $scope.navigation = NavigationService.getnav();
        $scope.mainnavigation = MainNavigationService.getnav();
  }]);
phonecatControllers.controller('intelligence', ['$scope', 'TemplateService', 'NavigationService','MainNavigationService',
  function ($scope, TemplateService, NavigationService, MainNavigationService) {
        $scope.template = TemplateService;
        $scope.menutitle = NavigationService.makeactive("Intelligence");
        TemplateService.title = $scope.menutitle;
        TemplateService.content = "views/intelligence.html";
        $scope.navigation = NavigationService.getnav();
      $scope.mainnavigation = MainNavigationService.getnav();
  }]);
phonecatControllers.controller('clients', ['$scope', 'TemplateService', 'NavigationService','MainNavigationService',
  function ($scope, TemplateService, NavigationService, MainNavigationService) {
        $scope.template = TemplateService;
        $scope.menutitle = NavigationService.makeactive("Clients");
        TemplateService.title = $scope.menutitle;
        TemplateService.content = "views/clients.html";
        $scope.navigation = NavigationService.getnav();
      $scope.mainnavigation = MainNavigationService.getnav();
  }]);
phonecatControllers.controller('partners', ['$scope', 'TemplateService', 'NavigationService','MainNavigationService',
  function ($scope, TemplateService, NavigationService, MainNavigationService) {
        $scope.template = TemplateService;
        $scope.menutitle = NavigationService.makeactive("Partners");
        TemplateService.title = $scope.menutitle;
        TemplateService.content = "views/partners.html";
        $scope.navigation = NavigationService.getnav();
      $scope.mainnavigation = MainNavigationService.getnav();
  }]);
phonecatControllers.controller('social', ['$scope', 'TemplateService', 'NavigationService','MainNavigationService',
  function ($scope, TemplateService, NavigationService, MainNavigationService) {
        $scope.template = TemplateService;
        $scope.menutitle = NavigationService.makeactive("Social");
        TemplateService.title = $scope.menutitle;
        TemplateService.content = "views/social.html";
        $scope.navigation = NavigationService.getnav();
      $scope.mainnavigation = MainNavigationService.getnav();
  }]);

phonecatControllers.controller('people', ['$scope', 'TemplateService', 'NavigationService','MainNavigationService',
  function ($scope, TemplateService, NavigationService, MainNavigationService) {
        $scope.template = TemplateService;
        $scope.menutitle = NavigationService.makeactive("People");
        TemplateService.title = $scope.menutitle;
        TemplateService.content = "views/people.html";
        $scope.navigation = NavigationService.getnav();
      $scope.mainnavigation = MainNavigationService.getnav();
  }]);
phonecatControllers.controller('clientspeak', ['$scope', 'TemplateService', 'NavigationService','MainNavigationService',
  function ($scope, TemplateService, NavigationService, MainNavigationService) {
        $scope.template = TemplateService;
        $scope.menutitle = NavigationService.makeactive("Client Speak");
        TemplateService.title = $scope.menutitle;
        TemplateService.content = "views/clientspeak.html";
        $scope.navigation = NavigationService.getnav();
      $scope.mainnavigation = MainNavigationService.getnav();
  }]);
phonecatControllers.controller('contact', ['$scope', 'TemplateService', 'NavigationService','MainNavigationService',
  function ($scope, TemplateService, NavigationService, MainNavigationService) {
        $scope.template = TemplateService;
        $scope.menutitle = NavigationService.makeactive("Contact");
        TemplateService.title = $scope.menutitle;
        TemplateService.content = "views/contact.html";
        $scope.navigation = NavigationService.getnav();
      $scope.mainnavigation = MainNavigationService.getnav();
  }]);


phonecatControllers.controller('headerctrl', ['$scope', 'TemplateService',
 function ($scope, TemplateService) {
        $scope.template = TemplateService;
  }]);



function AlertDemoCtrl($scope) {
    $scope.alerts = [
        {
            type: 'danger',
            msg: 'Oh snap! Change a few things up and try submitting again.'
        },
        {
            type: 'success',
            msg: 'Well done! You successfully read this important alert message.'
        }
    ];

    $scope.addAlert = function () {
        $scope.alerts.push({
            msg: 'Another alert!'
        });
    };

    $scope.closeAlert = function (index) {
        $scope.alerts.splice(index, 1);
    };

}
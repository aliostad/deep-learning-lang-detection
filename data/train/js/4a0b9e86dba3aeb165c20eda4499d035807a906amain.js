AppModule = angular.module('isproject', ['ngRoute', 'ngResource']);

AppModule = AppModule.controller('UserController', UserController);
AppModule = AppModule.controller('ReportController', ReportController);
AppModule = AppModule.controller('SessionController', SessionController);
AppModule = AppModule.controller('SimController', SimController);
AppModule = AppModule.controller('NodeController', NodeController);
AppModule = AppModule.controller('PermissionController', PermissionController);

angular.bootstrap(document, ['isproject']);

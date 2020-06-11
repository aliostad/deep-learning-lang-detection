var dashboardApp = angular.module('dashboardApp', ['ui.bootstrap', 'highcharts-ng']);

dashboardApp.service('chartdataService', ['$rootScope', '$http', chartdataService]);

dashboardApp.factory('signalRHubProxy', ['$rootScope', signalRHubProxy]);

dashboardApp.controller('dashboardController', ['$scope', '$log', dashboardController]);
dashboardApp.controller('customerController', ['$scope', 'signalRHubProxy', customerController]);
dashboardApp.controller('chartController', ['$scope', '$log', '$timeout', '$interval', 'chartdataService', 'signalRHubProxy', chartController]);
dashboardApp.controller('piechartController', ['$scope', '$log', '$timeout', piechartController]);
dashboardApp.controller('linechartController', ['$scope', '$log', '$timeout', '$interval', 'chartdataService', linechartController]);
dashboardApp.controller('serverPerformanceController', ['$scope', 'signalRHubProxy', serverPerformanceController]);



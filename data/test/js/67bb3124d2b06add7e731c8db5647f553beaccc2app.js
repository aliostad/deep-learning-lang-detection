var app = angular.module("serviceMonitorService", ['angularMoment', 'LocalStorageModule']);
app.constant('DISPLAY_REFRESH_INTERVAL', '2000');
app.constant('API_URL', '/api/service');
app.controller("servicesCtrl", ServiceController);
app.controller("sidebarCtrl", SidebarController);
app.service('errorReportingService', ErrorReportingService);
app.service('serviceService', ServiceService);
app.service('stateService', StateService);
app.service('uiState', UiStateService);

app.run(function(errorReportingService) {});

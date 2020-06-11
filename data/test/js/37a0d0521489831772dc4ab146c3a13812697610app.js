var GPXMapsControllers = angular.module('GPXMapsControllers', ['ui.grid', 'ui.grid.selection', 'ui.grid.edit']);

var commonDependencies = [ '$rootScope', '$scope', '$http', '$timeout']; 

var controllers = [
	['GodController', [GodController]],
	['ModalController', [ModalController]],

	['UserActivationController', [UserActivationController]],
	['LoginController', [LoginController]],

	['GpxImportController', [GpxImportController]],
	['GpxExportController', [GpxExportController]],

	['GpxDatabaseController', [GpxDatabaseController]],
	['GpxController', [GpxController]],
	['GpxEditorController', [GpxEditorController]],

	['TracksController', [TracksController]],
	['ElevationPlotController', [ElevationPlotController]],
	['MapController', [MapController]],
	['WaypointsController', [WaypointsController]],
	['HelpController', [HelpController]],
];

controllers.forEach(function(ctrl) { 
	GPXMapsControllers.controller(ctrl[0], commonDependencies.concat(ctrl[1]));
});

var appName = 'GPXMapsApp';
var appDependencies = ['GPXMapsControllers'];  
var GPXMapsApp = angular.module(appName, appDependencies);
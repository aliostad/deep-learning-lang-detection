/*
 * Modules
 * 
 * This is where dependency injection is carried out
 * @author Dennis Höting
 */
var appModule = angular.module('app', ['filters', 'directives', 'idServices', 'servletCommunicationServices', 'simulationModule', 'mapServices', 'popupServices', 'callbackServices', 'consoleServices', 'eventLogServices']).
	
	/*
	 * Inject MapService
	 */
	factory('MapService', function(OpenLayersService) {
		return OpenLayersService;
	}).
	
	/*
	 * Inject ServletCommunicationService
	 */
	factory('ServletCommunicationService', function(WebSocketService) {
		return WebSocketService;
	}).
	
	/*
	 * Inject PopupService
	 */
	factory('PopupService', function(SimplePopupService) {
		return SimplePopupService;
	}).
	
	/*
	 * Inject ConsoleService
	 */
	factory('ConsoleService', function(SimpleConsoleService) {
		return SimpleConsoleService;
	}).
	
	/*
	 * Inject CallbackService
	 */
	factory('CallbackService', function(SimpleCallbackService) {
		return SimpleCallbackService;
	}).
	
	/*
	 * Inject EventLogService
	 */
	factory('EventLogService', function(SimpleEventLogService) {
	    return SimpleEventLogService;
	}).
	
	/*
	 * Inject MessageIDService
	 */
	factory('MessageIDService', function(SimpleMessageIDService) {
		return SimpleMessageIDService;
	});


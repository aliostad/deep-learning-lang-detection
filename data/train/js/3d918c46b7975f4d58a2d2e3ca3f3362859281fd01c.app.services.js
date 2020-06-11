"use strict";
/*  ================================================================================
	Services
================================================================================  */
angular
	.module('Services', [])
		/* ================================================================================
	 #IssuesSvc: Repository Issues Service
	 ================================================================================ */
	.factory(
		'IssuesSvc', [
			'$rootScope', 'Log', '$resource', '$filter', 'ParametersSvc',
			function($rootScope, Log, $resource, $filter, ParametersSvc) {
				var service = {
					_name: 'IssuesSvc',
					resourceParams:  {
						path: 'https://api.github.com/issues',
						params: {
						},
						actions: {
							getIssues: {
								method: 'GET',
								isArray: true
							}
						}
					}
				};

				/* ==== INIT VARIABLES ==================== */
				service.init = function() {
					Log.debug([service._name, service, 'init']);
					service.resource = $resource(service.resourceParams.path, service.resourceParams.params, service.resourceParams.actions);
					return service;
				};

				/* ==== FUNCTIONS ==================== */
				service.getIssues = function(){
					service.issues = service.resource.getIssues();
				};

				/* ==== BROADCASTS ==================== */

				/* ==== LISTENERS ==================== */
				$rootScope.$on('Services:init', function() {
					// Reinitialise service.
					service.init();
				});

				return service.init(); // Return Service
			}
		]
	)
;
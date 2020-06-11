/**
@module ang-layout
@class ang-header
*/

'use strict';

angular.module('myApp').controller('HeaderCtrl', ['$scope', 'appNav', 'appConfig', function($scope, appNav, appConfig) {
	$scope.nav ={};
	
	$scope.classes ={
		cont: ''
	};
	
	var nav;
	
	/**
	@method init
	*/
	function init(params) {
		nav =appNav.getNav({});
		if(nav !==undefined && nav) {		//avoid errors (on init??)
			//have to get login status on first time
			var ppSend ={};
			ppSend.loggedIn =appConfig.state.loggedIn;
			nav =navLoginUpdate(nav, ppSend);
			appNav.setNav(nav, {});			//save in nav service as well so other controllers, etc. can access this UPDATED / current nav
			setNav(nav.header, {});
		}
	}
	
	/**
	@method setNav
	*/
	function setNav(nav, params) {
		if(nav !==undefined && nav) {		//avoid errors (on init??)
			$scope.nav =nav;
			if($scope.nav.classes !==undefined && $scope.nav.classes.cont !==undefined && $scope.nav.classes.cont =='hidden') {
				$scope.classes.cont =$scope.nav.classes.cont;
			}
			else {
				$scope.classes.cont ='';		//reset to default
			}
		}
		// else {
			// console.log('HeaderCtrl: nav undefined');
		// }
	}
	
	/**
	@param {Object} params
		@param {Object} nav
	*/
	$scope.$on('appNavHeaderUpdate', function(evt, params) {
		setNav(params.nav.header, {});
	});
	
	/**
	Handles post login (or reverse for logout) - need to update nav header (toggle between login / logout)
	@toc 2.
	@method $scope.$on('loginEvt',..
	@param {Object} params
		@param {Boolean} [loggedIn] true if logged in
	*/
	$scope.$on('loginEvt', function(evt, params) {
		nav =appNav.getNav({});		//re-get
		nav =navLoginUpdate(nav, params);
		appNav.setNav(nav, {});
	});
	
	/**
	@toc 2.5.
	@method navLoginUpdate
	@param {Object} nav
	@param {Object} params
		@param {Boolean} loggedIn true if logged in
	*/
	function navLoginUpdate(nav, params) {
		if(params.loggedIn) {		//show logout button
			nav.header.buttons.right[0] ={
				icon: 'fa fa-sign-out',
				iconHtml: 'Logout',
				href: $scope.appPathLink+'logout'
			};
		}
		else {			//logged out - show login button
			nav.header.buttons.right[0] ={
				icon: 'fa fa-sign-in',
				iconHtml: 'Login',
				href: $scope.appPathLink+'login'
			};
		}
		return nav;
	}
	
	//init (since first load the $scope.$on may not be called)
	init({});
	
}]);
/**
 * Created by mhebert on 3/12/2015.
 */
/**
 * @module *.directive.nav
 * @file directive for the apps navigation
 */
angular.module('foundationApp.directive.nav', ['ui.router'])
    .directive('foundationNav', navImpl)
    .controller('Nav', Nav);

/**
 * @method navImpl
 * @description implementation details
 * @returns {{
 *  restrict: string, templateUrl: string,
 *  replace: boolean, controller: string, controllerAs: string,
 *  bindToController: boolean
 * }}
 */
function navImpl() {
    return {
        restrict: 'E',
        templateUrl: 'shared/nav/nav.html',
        replace: false,
        controller: 'Nav',
        controllerAs: 'nav',
        bindToController: true
    };
}

/**
 * @class Nav
 * @constructor
 * @param {object} states
 */
function Nav() {
    'use strict';


}

//function toggleMobileNav() {
//    var mobileActive = (mobileActive) ? false : true;
//    return mobileActive;
//}

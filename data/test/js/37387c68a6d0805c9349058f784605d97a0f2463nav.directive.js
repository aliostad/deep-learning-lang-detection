/**
 * Created by chagen on 5/19/16.
 */
(function () {
    'use strict';
    var navCtrl = function($state, NavService, NAV_LINKS) {
        var vm = this;
        vm.links = NAV_LINKS;
console.log("NAV SERVICE", NavService)
        vm.go = function (state) {
            NavService.activeState = state;
            $state.go(state);
        };

        vm.isActiveState = function(currentTab) {
            return NavService.activeState === currentTab;
        } ;
    };

    angular.module('movieApp')
        .component('movieNav', {
            templateUrl: 'app/components/nav/nav.html',
            controller: navCtrl,
            controllerAs: 'nav'
        })
        .service('NavService', function (NAV_LINKS) {
            this.activeState = NAV_LINKS.UPCOMING;
        })
        .constant("NAV_LINKS", {
            "HOME": "upcoming",
            "FAVORITES": "favorites",
            "IN_THEATRES": "now-playing",
            "TOP_RATED": "top-rated",
            "UPCOMING": "upcoming"
        });
})();
'use strict';

var ELHAppDirectives = angular.module('ELHAppDirectives');

ELHAppDirectives.directive('sidemenuToggle', function(){
    return {
        restrict: "A",
        link: function(scope, elem, attrs){
            $(elem).click(function(){
                toggleNav();
            });

            function toggleNav() {
                if ($('#content-canvas').hasClass('show-nav')) {
                    // Do things on Nav Close
                    $('#content-canvas').removeClass('show-nav');
                    $('.fixed-header').removeClass('show-nav');
                    $('.sidemenu').removeClass('show-nav');
                } else {
                    // Do things on Nav Open
                    $('#content-canvas').addClass('show-nav');
                    $('.fixed-header').addClass('show-nav');
                    $('.sidemenu').addClass('show-nav');
                }
            }
        }

    }
});
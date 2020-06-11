/*
   Service: aw.webapp.commonService
*/

(function() {
    'use strict';

    angular
        .module( 'aw.webapp.commonService' )
        .service('CommonService',  CommonService);

    function  CommonService() {
        'ngInject';
        
        var service = this;
        
        service.count = 0;


        service.add = function( value ) {
            var _value = parseInt( value ) || 1;

            service.count += _value;
        };

         service.reduce = function() {
            if ( service.count > 0 ) service.count -= 1;
        };
    }   
})();
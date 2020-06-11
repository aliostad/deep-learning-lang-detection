(function() {
    
    'use strict';
    
    var app = angular.module('App', []);
    
    angular.module('global.filter', []);
    
    angular.module('global.service', []);
    angular.module('login.service', []);
    angular.module('menu.service', []);
    angular.module('indexation.service', []);
    angular.module('search.service', []);
    angular.module('sendmail.service', []);
    
    angular.module('App',
            ['pascalprecht.translate', 'angular-jqcloud', 'ui.bootstrap', 'ngSanitize', 
             'global.filter', 
             'global.service', 'login.service', 'menu.service',
             'indexation.service', 'search.service', 'sendmail.service']);
    
})();
(function () {
    'use strict';
    global.$ = global.jQuery = require('jquery');
    global.angular = require('angular');
    global.rangy = require('rangy');
    require('angular-ui-router');
    require('angular-sanitize');
    require('angular-messages');
    require('angular-animate');
    require('angular-aria');
    require('angular-material');
    require('textangular');
    var angular = require('angular'),
        app;
    var
    /*Controllers*/
        homeController = require('./controllers/homeController'),
        loginController = require('./controllers/loginController'),
        shellController = require('./controllers/shellController'),
        searchController = require('./controllers/searchController'),
        dashboardController = require('./controllers/dashboardController'),
        groupController = require('./controllers/groupController'),
        questionController = require('./controllers/questionController'),

    /*Dialogs*/
        newUserController = require('./controllers/dialogs/newUserController'),
        newGroupController = require('./controllers/dialogs/newGroupController'),
        newQuestionController = require('./controllers/dialogs/newQuestionController'),
    /*Services*/
        UserService = require('./services/UserService'),
        GroupService = require('./services/GroupService'),
        QuestionService = require('./services/QuestionService'),
        ResourceService = require('./services/ResourceService'),
        ToastService = require('./services/ToastService'),
    /*Directives*/
        goClickDirective = require('./directives/goClick'),
        equalsDirective = require('./directives/equals'),
    /*Configs*/
        routerConfig = require('./config/router'),
        iconsConfig = require('./config/icons'),
        textAngularConfig = require('./config/textAngular'),
        themeConfig = require('./config/theme');
    app = angular.module('app', [
            'ui.router',
            'ngAnimate',
            'ngAria',
            'ngMessages',
            'ngSanitize',
            'ngMaterial',
            'textAngular'
        ])
        .controller('homeController', homeController)
        .controller('dashboardController', dashboardController)
        .controller('loginController', loginController)
        .controller('shellController', shellController)
        .controller('newUserController', newUserController)
        .controller('newGroupController', newGroupController)
        .controller('newQuestionController', newQuestionController)
        .controller('searchController', searchController)
        .controller('dashboardController', dashboardController)
        .controller('groupController', groupController)
        .controller('questionController', questionController)
        .factory('UserService', UserService)
        .factory('GroupService', GroupService)
        .factory('QuestionService', QuestionService)
        .service('ResourceService', ResourceService)
        .service('ToastService', ToastService)
        .directive('goClick', goClickDirective)
        .directive('equals', equalsDirective)
        .config(routerConfig)
        .config(iconsConfig)
        .config(textAngularConfig)
        .config(themeConfig);

})();

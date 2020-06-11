/**
 * Module dependencies
 */

var CommittedApp = require('app'),
    ShowController = require('./show/show_controller');


CommittedApp.module('AuthApp', function (AuthApp, CommittedApp, Backbone, Marionette, $, _) {
    AuthApp.Router = Marionette.AppRouter.extend({
        appRoutes: {
            'login': 'showLogin',
            'signup': 'showSignup',
            'logout': 'logout'
        }
    });

    var API = {
        showLogin: function () {
            ShowController.showLogin();
        },

        showSignup: function () {
            ShowController.showSignup();
        },

        logout: function () {
            CommittedApp.trigger('user:logout');
        }
    };

    AuthApp.addInitializer(function () {
        var authRouter = new AuthApp.Router({
            controller: API
        });
    });

    CommittedApp.on('login:show', function () {
        CommittedApp.navigate('login');
        API.showLogin();
    });

    CommittedApp.on('signup:show', function () {
        CommittedApp.navigate('signup');
        API.showSignup();
    });

    module.exports = AuthApp.Router;
});
KarklaskApp.module('ShowApp', function(ShowApp, App, Backbone, Marionette, $, _) {
    'use strict';

    ShowApp.Router = Marionette.AppRouter.extend({
        appRoutes: {
            '(/)show': 'show',
            '(/)show/:grades': 'show'
        }
    });

    var API = {
        show: function(collection) {

            if(collection === undefined) {
                App.vent.trigger('show:input');
                return;
            }

            if(typeof collection === "string") {
                var c = window.c = JSON.parse(atob(collection));
                collection = new KarklaskApp.Entities.Grades(c);
            }
            new ShowApp.Controller(collection);
        }
    };

    ShowApp.addInitializer(function() {
        new ShowApp.Router({
            controller: API
        });
    });

    App.vent.on('display', function(collection) {
        API.show(collection)
        Backbone.history.navigate('show');
    });
})  
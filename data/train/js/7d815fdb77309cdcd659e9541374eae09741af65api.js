define([
    'app',
    'apps/main/entities/users/api',
    'apps/main/entities/operations/api',
    'apps/main/entities/ledgers/api'
], function (App, Users, Operations, Ledgers) {
    App.module('Main.Entities.API', {
        define: function (API, App, Backbone, Marionette, $, _) {
            API.API = M.Controller.extend({
                init: function(options) {
                    this.initController('user', Users.API);
                    this.initController('operations', Operations.API);
                    this.initController('ledgers', Ledgers.API);
                }
            });
        }
    });

    return App.Main.Entities.API;
});
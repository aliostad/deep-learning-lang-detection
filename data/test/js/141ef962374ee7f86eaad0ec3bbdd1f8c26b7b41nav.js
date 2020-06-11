/* globals _, Backbone */

define([
  'application',
  'text!apps/nav/nav.jst'         // Adding IETF language tag
], function(App, NavTemp) {
  'use strict';

  var NavApp = App.module('NavApp', function(NavApp) {
    NavApp.addInitializer(function() {
      console.log('NavApp has been initialized.');

      var NavView = Backbone.Marionette.ItemView.extend({
        template: _.template(NavTemp)
      });

      NavApp.ShowModule = function() {
        return new NavView();
      };

    });
  });

  return NavApp;
});
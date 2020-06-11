(function() {
  define(["js/app", "js/apps/nav_app/show/show_view"], function(App, View) {
    App.Entity.Navigation = Backbone.Model.extend();
    App.module("NavApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      return Show.Controller = {
        showNavigation: function() {
          var navigation;
          navigation = new App.Entity.Navigation({
            statelist: "All artists",
            statelocation: "All locations",
            statebio: ""
          });
          console.log("navigation", navigation);
          this.showView = new View.ShowView({
            model: navigation
          });
          return App.navRegion.show(this.showView);
        }
      };
    });
    return App.NavApp.Show.Controller;
  });

}).call(this);

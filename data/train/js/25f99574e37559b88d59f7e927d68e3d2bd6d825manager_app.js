MA.module('Manager', function(Manager, MA, Backbone, Marionette, $, _) {
  this.startWithParent = false;

  var API = {
    showMovies: function() {
      var manager = new Manager.Show.Controller();
      manager.showAllMovies();
      Backbone.history.navigate("#/mymovies");
    },

    showAddMovie: function(genre) {
      var manager = new Manager.Show.Controller();
      manager.showNewMovie();
      Backbone.history.navigate("#/mymovies/new");
    },

    showEditMovie: function(genre) {
      var manager = new Manager.Show.Controller();
      manager.showEditMovie(genre);
    }

  };

  MA.commands.setHandler("manager:start", function() {
    API.showMovies();	
  })

});

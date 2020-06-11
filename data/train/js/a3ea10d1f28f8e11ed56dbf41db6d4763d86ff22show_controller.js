App.module("LibraryApp.Show", function(Show, App, Backbone, Marionette, $, _){
  Show.Controller = {
    showLibrary: function(){
      var viewLibraryLoyout = new Show.Layout();

      var libraryTopView = new Show.libraryTopView();
      var libraryBottomView = new Show.libraryBottomView();

        viewLibraryLoyout.on("show", function() {
        viewLibraryLoyout.LibraryTopViewRegion.show(libraryTopView) ;
        viewLibraryLoyout.LibraryBottomViewRegion.show(libraryBottomView) ;
        });

      App.mainRegion.show(viewLibraryLoyout);
    }
  };
});

define(["App", "marionette"], function(App, Marionette){

    var Router = Marionette.AppRouter.extend({
        appRoutes: {
            "footer" : "showFooter"
        }
    });

    var API = {
        showFooter: function(){
            require(["subapps/footer/show/ShowController"], function(ShowController){
                ShowController.showFooter();
            });
        }
    };

    App.on("footer:show", function(){
        API.showFooter();
    });

    App.addInitializer(function(){
        new Router({
            controller: API
        });
    });

    return Router;
});
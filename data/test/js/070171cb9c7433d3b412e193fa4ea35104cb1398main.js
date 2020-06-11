$(document).ready(function() {

    var Controller = {
        showHomePage: function () {
            $('#home').show();
            $('#profile').hide();
        },

        showProfilePage: function () {
            $('#home').hide();
            $('#profile').show();
        }
    }

    var AppRouter = Backbone.Router.extend({
        routes: {
            'home': 'showHomePage',
            'profile': 'showProfilePage'
        },
        
        showHomePage: function() {
            Controller.showHomePage();
        },
        
        showProfilePage: function() {
            Controller.showProfilePage();
        }
    });

    var appRouter = new AppRouter();

    Backbone.history.start();
    Backbone.history.navigate("home");
    Controller.showHomePage();
});
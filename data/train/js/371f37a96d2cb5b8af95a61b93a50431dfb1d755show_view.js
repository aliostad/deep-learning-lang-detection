PocApp.module("HeaderApp.Show", function (Show, App, Backbone, Marionette, $, _) {

    Show.Layout = Marionette.Layout.extend({
        template: "header/show/templates/show_layout",

        regions: {
            menuRegion:     "#menu-region",
            loginRegion:    "#login-region"
        }
    });

    Show.Menu = Marionette.ItemView.extend({
        template: "header/show/templates/_menu",
        tagName: "li"
    });

    Show.Menus = Marionette.CompositeView.extend({
        template: "header/show/templates/_menus",
        itemView: Show.Menu,
        itemViewContainer : "ul"
    });

    Show.Login = Marionette.ItemView.extend({
        template: "header/show/templates/_login"
    });

    Show.Authenticated = Marionette.ItemView.extend({
        template: "header/show/templates/_authenticated",

        triggers: {
            "click #signout": "signout:button:clicked"
        }
    });

});
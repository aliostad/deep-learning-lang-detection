tiy.Router = Backbone.Router.extend({

    routes: {
        "" : "clear",
        "pageone" : "showPageOne",
        "pagetwo" : "showPageTwo"
    },

    initialize: function() {

        var page = React.createElement(tiy.views.Page, {
            // property onShow is given the function showPages
            onShow: this.showPages.bind(this)
        });

        this.page = React.render(page, document.body); 
    },

    showPages: function(page) {
        console.log(page);
        if(page === "pageone") {
            this.showPageOne();
            this.navigate("pageone");
        }
        else if (page === "pagetwo") {
            this.showPageTwo();
            this.navigate("pagetwo");
        }
    },

    showPageOne: function() {
        this.page.setProps({show: "pageone"});
    },

    showPageTwo: function() {
        this.page.setProps({show: "pagetwo"});
    },

    clear: function() {
        this.page.setProps({show: null});
    }



});
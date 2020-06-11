define(
[
'backbone' ,
'Views/page'
],

function( 
Backbone,
PageView 
) {


  Router = Backbone.Router.extend({

    routes: {
        ""              : "showHome",
        "home"          : "showHome",
        "explore-us"    : "showWeAre",
        "blog"          : "showBlog",
        "contact"       : "showContact",
        "western-ghats" : "showWestern"
    },

    initialize: function () {
      console.log("initialize router");
      this.app = new PageView();      
    },

    home: function () {
        this.app.showAll();
    },
    showHome:function(){
      this.app.showHome();
    },
    showWeAre:function(){
      this.app.showWeAre();
    },
    showBlog:function(){
      this.app.showBlog();
    },
    showContact:function(){
      this.app.showContact();
    },
    showWestern:function(){
      this.app.showWestern();
    }
  });
  return Router;
});


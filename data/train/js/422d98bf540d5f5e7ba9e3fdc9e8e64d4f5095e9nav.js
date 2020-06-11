define([
   'underscore',
   'backbone'
    ], function(_, Backbone) {

        var Nav = Backbone.Model.extend({});

        var NavHome = new Nav({
                link: 'Я',
                url: '#'
            });

        var NavCSS = new Nav({
                link: 'Работа',
                url: '#/work'
            });

        var NavJS = new Nav({
                link: 'Семья',
                url: '#/family'
            });
        
        var NavJQuery = new Nav({
                link: 'Связь',
                url: '#/contact'
            });

        var Navs = Backbone.Collection.extend({});
        var navs = new Navs([NavHome, NavCSS, NavJS, NavJQuery]);

        return navs;

});
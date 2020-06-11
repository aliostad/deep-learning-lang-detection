App.Views.BaseScreen = Backbone.View.extend({

    initialize: function(name) {
        this.name = name;
    },

    preShow: function(options, callback, scope) {
        var result = this._preShow(options, callback, scope);
        if (result !== false) {
            callback.call(scope || window);
        }
    },

    _preShow: function(options, callback, scope) {

    },

    postShow: function() {
        this._postShow();
    },

    _postShow: function() {

    },

    show: function() {

        this.$el.show();
        return this;

    },

    hide: function() {

        this.$el.hide();
        return this;
        
    }

});
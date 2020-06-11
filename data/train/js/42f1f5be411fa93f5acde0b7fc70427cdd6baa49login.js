define([
  'backbone'
], function (Backbone) {
    var LoginModel = Backbone.Model.extend({

        defaults: {
            loggedIn: false,
            apiKey: null
        },

        initialize: function () {
            this.bind('change:apiKey', this.onApiKeyChange, this);
            this.set({ 'apiKey': localStorage.getItem('apiKey') });
        },

        onApiKeyChange: function (status, apiKey) {
            this.set({ 'loggedIn': !!apiKey });
        },

        setApiKey: function (apiKey) {
            localStorage.setItem('apiKey', apiKey)
            this.set({ 'apiKey': apiKey });
        }
    });
    return LoginModel;
});
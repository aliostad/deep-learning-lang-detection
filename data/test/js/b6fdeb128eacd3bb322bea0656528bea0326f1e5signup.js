import Ember from 'ember';

export default Ember.Route.extend({
  
    activate: function() {

        var controller = this.get('controller');
        if (controller) {
            controller.clearMessages();
            controller.set('completed', false);
        }

        this.redirectIfLoggedIn(controller);
    },

    setupController: function (controller) {
        this.redirectIfLoggedIn(controller);
    },

    redirectIfLoggedIn: function (controller) {
        if (!controller) {
            return;
        }
        if (controller.get('session.isAuthenticated')) {
            this.transitionTo('projects');
        }
    }
});
import Ember from 'ember';

export default Ember.Route.extend({
	beforeModel: function(){
		var controller = this.controllerFor('application');
		controller.set('inAddProject', true);
		controller.set('normalNav', false);
	},
	setupController: function(controller, model){
		controller.set('departments', this.store.find('department'));
		controller.set('universities', this.store.find('university'));
		controller.set('model', model);
	},
	actions: {
		willTransition: function(){
			var controller = this.controllerFor('application');
			controller.set('inAddProject', false);
			controller.set('normalNav', true);
		}
	}
});

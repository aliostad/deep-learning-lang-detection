Myshopee.ItemRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    this._super.apply(this, arguments);

    if (controller.get('isEditing')) {
      controller.stopEditing();
    }

    this.controllerFor('items').set('activeContactId', model.get('id'));
  },

  deactivate: function() {
    var controller = this.controllerFor('item');

    if (controller.get('isEditing')) {
      controller.stopEditing();
    }

    this.controllerFor('items').set('activeContactId', null);
  }
});

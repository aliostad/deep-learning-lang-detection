Shepherd.UsersController = Ember.ArrayController.extend({
    sortProperties: ['lastName'],
    sortAscending: true
});

Shepherd.UsersIndexController = Ember.ObjectController.extend({});

Shepherd.UserController = Ember.ObjectController.extend(Shepherd.ResourceControllerMixin, {});

Shepherd.UserShowController = Ember.ObjectController.extend({
    needs: ['user'],
    uri: Ember.computed.alias('controllers.user.uri'),
});

Shepherd.UsersNewController = Shepherd.UserShowController.extend(Shepherd.EditModelControllerMixin, {});

Shepherd.UserEditController = Shepherd.UsersNewController.extend({});

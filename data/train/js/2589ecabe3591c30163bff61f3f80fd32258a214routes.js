Router.configure({
  layoutTemplate: 'layout'
});

var GeoController = RouteController.extend({
  waitOn: function () {
    return [Meteor.subscribe('states'),
      Meteor.subscribe('counties')];
  } 
});


Router.map(function() {
  this.route('dashboard', {
    controller: GeoController
  });
  this.route('check-in', {
    controller: GeoController
  });
  this.route('filter', {
    controller: GeoController
  });
  this.route('feed', {
    controller: GeoController
  });

  this.route('default', {
    controller: GeoController,
    path: '*',
    action: function () {
      Router.go('/dashboard');
    }
  });
});

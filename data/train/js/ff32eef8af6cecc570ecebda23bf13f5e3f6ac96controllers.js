AppController = RouteController.extend({
  layoutTemplate: 'appLayout',
  onBeforeAction: function () {
    // do some login checks or other custom logic
    this.next();
  }
});

LandingpageController = AppController.extend({
  // EXAMPLE:
  // waitOn: function () {
  //   return Meteor.subscribe('products');
  // },
  // data: function () {
  //   return {
  //     products: Products.find({}, {sort: {numberOfVotes: -1, name: -1}})
  //   };
  // }
});

BusinesscreateController = AppController.extend({});
CampaignscreateController = AppController.extend({});
CampaignslistController = AppController.extend({});
LoginController = AppController.extend({});
ProfileController = AppController.extend({});
CamerafeatureController = AppController.extend({});


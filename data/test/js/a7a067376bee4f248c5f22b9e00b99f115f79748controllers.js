

App.notificationsController = Yvi.NotificationsController.create({
});
App.loginUserController = Yvi.LoginUserController.create({});

App.nearUsersController = Yvi.NearUsersController.create({
  loginUserController: App.loginUserController,
  settings: App.settings
});

App.inboxInvitationsController = Yvi.InboxInvitationsController.create({});
App.archivedInvitationsController = Yvi.BaseWalletController.create({});

App.walletController = Yvi.WalletController.create({
  loginUserController: App.loginUserController,

  inboxInvitationsController: App.inboxInvitationsController,
  archivedInvitationsController: App.archivedInvitationsController

});




App.categoryController = Yvi.CategoryController.create({});

App.cityController = Em.ArrayController.create({
  content: null,
  defaultCity: null,
  selected: null

});

App.facebookUserController = Yvi.FacebookUserController.create({

});

App.friendsController = Yvi.FriendsController.create({

});

App.friendsNearbyController = Em.Object.create({
	venue: null,
  people: null

});

App.geopositionController = Yvi.GeopositionController.create({
  settings: App.settings,
  cityController: App.cityController,
  nearUsersController: App.nearUsersController
});

App.inviteController = Yvi.InviteController.create({
  geopositionController: App.geopositionController

});

App.venuesController = Yvi.VenuesController.create({
  geopositionController: App.geopositionController,
  settings: App.settings

});

App.geopositionController.venuesController = App.venuesController;



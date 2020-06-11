AppController = RouteController.extend({
  layoutTemplate: 'appLayout'
});

ExploreController = AppController.extend({});

CategoryController = AppController.extend({});

RecentController = AppController.extend({});

ProductsShowController = AppController.extend({});

FavoritesController = AppController.extend({});

BookingsController = AppController.extend({});

BookingDetailController = AppController.extend({});

UsersShowController = AppController.extend({});

NotificationsController = AppController.extend({});

ProfileController = AppController.extend({});

ProductCreationController = AppController.extend({});

ChatController = AppController.extend({
  layoutTemplate:'appLayoutNoNav'
});
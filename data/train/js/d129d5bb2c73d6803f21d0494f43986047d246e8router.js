define(function (require){
	var Backbone = require('backbone'),
			AnnouncementsController = require('controllers/announcements.controller'),
			ContactsController = require('controllers/contacts.controller'),
			ShiftsController = require('controllers/shifts.controller'),
			ResourcesController = require('controllers/resources.controller'),
			LoginController = require('controllers/login.controller'),
			LogoutController = require('controllers/logout.controller'),
			SignupController = require('controllers/signup.controller');

	var AppRouter = Backbone.Router.extend({

		_currentController: null,

		_updateCurrentController: function(currentController){

			if(this._currentController){
	  		this._currentController.destroy();
	  	}

			this._currentController = currentController;
		},

		routes: {
			"home": 					"announcements",
			"announcements":  "announcements", 
	    "contacts":      	"contacts",    // #contacts
	    "shifts":        	"shifts",  // #shifts
	    "resources": 			"resources",   // #resources
	    "login": 					"login", // #login
	    "signup":         "signup",
	    "logout":         "logout"
	  },

	  announcements: function(){

	  	this._updateCurrentController(AnnouncementsController);

	  	AnnouncementsController.start();
	  },

  	contacts: function(){

  		this._updateCurrentController(AnnouncementsController);

  		ContactsController.start();
  	},

	  shifts: function(){

	  	this._updateCurrentController(ShiftsController);

			ShiftsController.start();
	  },

	  resources: function(){

	  	this._updateCurrentController(ResourcesController);

	  	ResourcesController.start();
	  },

	  login: function(){

	  	this._updateCurrentController(LoginController);

	  	LoginController.start();
	  },

	  signup: function(){

	  	this._updateCurrentController(SignupController);

	  	SignupController.start();
	  },

	  logout: function(){

	  	this._updateCurrentController(LogoutController);

	  	LogoutController.start();
	  }
	});

	return AppRouter;
});
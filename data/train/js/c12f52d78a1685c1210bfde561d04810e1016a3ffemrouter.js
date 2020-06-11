define(function(require){
	var Backbone = require('backbone');
	
	var AppRouter = Backbone.Router.extend({

		initialize : function(options){
			this.options = _.extend({
				//Defaults here
			}, options);
		},
		  routes: {
				"menu" : "showMenu",
			    "dashboard": "showDashboard",    
			    "newexpense": "showNewExpense",  
			    "creategroup": "showCreateGroup"   ,
			    "expensehistory": "showExpenseHistory",    
			    "editgroup": "showEditGroup",  
			    "profile": "showProfile"   
		  },
		  showMenu : function(){
			  this.options.view.eventShowMenu();
		  },
		  showDashboard: function(query, page) {
			  this.options.view.eventShowView('js-dashboard');
		  },
		  showNewExpense: function(query, page) {
			  this.options.view.eventShowView('js-new-expense'); 
		  },
		  showCreateGroup: function(query, page) {
			  this.options.view.eventShowView('js-create-group');
		  },
		  showExpenseHistory: function(query, page) {
			  this.options.view.eventShowView('js-expense-history');
		  },
		  showEditGroup: function(query, page) {
			  this.options.view.eventShowView('js-edit-group');
		  },
		  showProfile: function(query, page) {
			  this.options.view.eventShowView('js-profile');
		  }

	});
	
	return AppRouter;
	
});
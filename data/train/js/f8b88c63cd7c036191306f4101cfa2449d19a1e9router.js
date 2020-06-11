var app = app || {};

app.Router = Backbone.Router.extend({	
	routes :{
		"" : "showJobs",
		"jobs" : "showJobs",
		"jobs/:id" : "showEditJob",
		"users" : "showUsers",
		"users/share/:id" : "showShareFile",
		"*path" : "showError"
	},

	initialize : function(app){
		this.RM = app.RegionManager;
	},

	showJobs : function(){
		this.RM.show(new app.JobPageView());
	},

	showEditJob : function(id){
		this.RM.show(new app.JobEditView({jobId : id}));
	},

	showUsers : function(){
		this.RM.show(new app.UserPageView());
	},

	showShareFile : function(id){
		this.RM.show(new app.UserShareView({userId : id}));
	},

	showError : function(path){
		$("#page-container").html("This is not valid");
	}
});

// js/views/stats.js

var app = app || {};

// Stats View
// --------------

app.StatsView = Backbone.View.extend({
	
	el: '#summary',
	
	// Cache the template function for a single item.
	statsTemplate: _.template( app.Templates.summaryStatsTemplate ),
	
	initialize: function(service) {
		//this.service = this.models.where('service');
		console.log(this);
		/*if (this.model) {
			this.service = this.model[0].attributes.service;
		} else {
			this.service = '';
		}*/
	},
	
	render: function(service) {
		this.service = service;
		var completed = app.Questions.where({completed:true, service:this.service}).length,
			total = app.Questions.where({service:this.service}).length,
			points = app.Questions.pointsForService(this.service);
		
		
		this.$el.append(this.statsTemplate({
			service: this.service,
			completed: completed,
			total: total,
			points: points
		}));
		
		return this;
	}
});
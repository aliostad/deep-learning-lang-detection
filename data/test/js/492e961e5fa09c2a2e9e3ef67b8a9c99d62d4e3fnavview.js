define([
  'jquery',
  'underscore',
  'backbone',
  'collections/portfolio/nav',
  'views/portfolio/navbtnview'
], function($, _, Backbone, NavCollection, NavBtnView, navTemplate) {
	
	var PortfolioNavView = Backbone.View.extend({

		el: '#portfolioNav',
		
		initialize: function() {
			this.collection = NavCollection;
			this.render();
		},
		
		render: function() {
			var that = this;
			this.collection.each(function(model) {
				that.$el.append(new NavBtnView({model: model}).el);
			});
			return this;
		}
		
	})

	return PortfolioNavView	
})
        


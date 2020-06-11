define(function(require) {
	var Backbone = require('backbone');

	return Backbone.Router.extend({
	//RecipeRouter

		$container	: $('.container'),
		$recipes 	: $('#recipes'),
		$history 	: $('#history'),

		routes: {
			'' 						: 'showRecipes',
			'history/model-:cid' 	: 'showHistory'
		},

		/* --- */

		showRecipes: function() {
			this.$recipes.show();
			this.$history.hide();
			console.log('router: showRecipes');
		},

		showHistory: function() {
			this.$history.show();
			this.$recipes.hide();
			console.log('router: showHistory');
		}

	});
});
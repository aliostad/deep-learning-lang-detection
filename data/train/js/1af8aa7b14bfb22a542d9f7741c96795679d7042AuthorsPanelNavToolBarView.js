/**
 * AuthorsPanelNavToolBarView.js
 *
 * Backbone view representing nav toolbar for ebooklibrary authors panel.
 *
 * (c)2014 mrdragonraaar.com
 */
define([
    'ebooklibrary/view/toolbar/NavToolBarView',
    'hbs!ebooklibrary/template/panel/authors/toolbar/AuthorsPanelNavToolBar',
    'backbone',
    'bootstrap'
],
function(
    NavToolBarView,
    AuthorsPanelNavToolBarTemplate,
    Backbone
) {
	var AuthorsPanelNavToolBarView = NavToolBarView.extend({
		tagName: 'ul',
		className: 'authors-nav panel-nav nav panel-left',
		template: AuthorsPanelNavToolBarTemplate,
		initialNavItemId: 'letter-all',

		/**
		 * Event handler for nav item select event.
		 * @param navItemId id of nav item.
		 * @param navItemGroup group name of nav item.
		 */
		onToolBarSelectNavItem: function(navItemId, navItemGroup) {
			if (navItemGroup === 'letter') {
				var letter = navItemId.substr(navItemGroup.length + 1);
				this.trigger('toolBarFilterBy', letter);
			}
		}
	});

	return AuthorsPanelNavToolBarView;
});

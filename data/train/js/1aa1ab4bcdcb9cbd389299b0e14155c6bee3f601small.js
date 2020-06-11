/* app/ui/nav/small */

define( 
	[
		'jquery'
	],

	function ( $ ) {

		var NavSmall;
		var $nav;
		var $navToggle;

		return {

			init: function () {
				NavSmall = this;
				NavSmall.initVars();
				NavSmall.bind();
			},

			initVars: function () {
				NavSmall = this;
				$nav = $('#menu');
				$navToggle = $('.js-menu-toggle');
			},

			bind: function () {
				this._setData();
				$navToggle.on('click', this._toggleSmallMenu);
				$nav.on('click', 'a', this._menuItemClick);
			},

			unbind: function () {
				$navToggle.off('click', this._toggleSmallMenu);
				$nav.off('click', 'a', this._menuItemClick);
				this._resetMenu();
				this._removeData();
			},

			_toggleSmallMenu: function ( event ) {
				event.preventDefault();
				$('body').toggleClass('open-menu');
			},
			
			_menuItemClick: function () {
				$('body').toggleClass('open-menu');
			},

			_setData: function () {
				$nav.data( 'nav', 'true' );
			},

			_removeData: function () {
				$nav.removeData( 'nav' );
			},

			_resetMenu: function () {
				if ( !$( '.no-touch' ).length ) {
					return;
				}

				if ( $nav.is( '.is-expanded' ) ) {
					$nav.toggleClass( 'is-expanded is-collapsed' );
					$nav.find('.is-expanded').removeClass('is-expanded');
				}

			}
		};

	}
);
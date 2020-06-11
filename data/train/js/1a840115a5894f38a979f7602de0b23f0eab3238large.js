/* app/ui/nav/large */

define( 
	[
		'jquery'
	],

	function ( $ ) {

		var NavLarge;
		var $nav;
		var $navToggle;

		return {
			init: function () {
				NavLarge = this;
				function atomicNav() {
					if (!$('#menu').data('nav')) {
						NavLarge.initVars();
						NavLarge.bind();
					} else {
						setTimeout( atomicNav, 50 );
					}
				}
				atomicNav();
			},

			initVars: function () {
				$nav = $('#menu');
				$navToggle = $('.js-menu-toggle');
			},

			bind: function () {
				this._setData();
				$navToggle.on( 'click', this._toggleLargeMenu );
			},
			
			unbind: function () {
				$navToggle.off( 'click', this._toggleLargeMenu );
				this._removeData();
			},

			_toggleLargeMenu: function ( event ) {
				event.preventDefault();
				$nav.slideToggle();
				$nav.toggleClass('is-open');
			},

			_setData: function () {
				$nav.data( 'nav', 'true' );
			},

			_removeData: function () {
				$nav.removeData( 'nav' );
			}

		};

	}
);
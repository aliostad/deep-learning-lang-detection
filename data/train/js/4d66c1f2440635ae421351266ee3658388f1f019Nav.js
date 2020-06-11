import $ from 'jquery';

class Nav {
	constructor() {
		this.openNavButton = $(".nav-button");
		this.nav = $(".nav");
		this.closeNavButton = $(".nav__close");
		this.events();
	}

	events() {
		// clicking the open nav button
		this.openNavButton.click(this.openNav.bind(this));

		// clicking the x close nav button
		this.closeNavButton.click(this.closeNav.bind(this));

		// pushes any key
		$(document).keyup(this.keyPressHandler.bind(this));
	}

	keyPressHandler(e) {
		if (e.keyCode == 27) {
			this.closeNav();
		}
	}

	openNav() {
		$("body").addClass("full-screen");
		this.nav.addClass("nav--is-open");
		return false;
	}
	closeNav() {
		$("body").removeClass("full-screen");
		this.nav.removeClass("nav--is-open");
	}
}

export default Nav;
navController = function() {
	var ctrl = this;

	this.navIcon = document.getElementsByClassName('nav-icon')[0];

	this.navContainer = document.getElementsByClassName('navigation-container')[0];

	this.navIcon.addEventListener('click', function() {
		ctrl.toggleNav();
	});

	this.navContainer.addEventListener('click', function(e) {
		console.log(e.target);
		ctrl.closeNav();
	})

};

navController.prototype.toggleNav = function() {
	this.navContainer.classList.toggle('open');
};

navController.prototype.closeNav = function() {
	this.navContainer.classList.remove('open');
};
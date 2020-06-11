var MenuController = function(controller){
	this.controller = controller;
	return this;
};

MenuController.prototype.viewDidLoad = function() {
	if (this.controller == null && top.controller) {
		this.controller = top.controller;
	} if (this.controller) {
		this.controller.menuController = this;
		this.hal = this.controller.hal;
	} else {
		this.hal = new Hal(this);
		this.hal.start();
	}
}

MenuController.prototype.openAlarmClock = function() {
	this.controller.openAlarmClock();
}

MenuController.prototype.openSpotifyRemote = function() {
	this.controller.openSpotifyRemote();
}

var menuController = new MenuController();

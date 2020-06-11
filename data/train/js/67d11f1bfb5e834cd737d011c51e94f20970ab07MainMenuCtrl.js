import '../services/ui/mainMenu';

angular.module('VirtualBookshelf')
.controller('MainMenuCtrl', function (mainMenu, authorization, selectLibrary) {
	this.isShow = mainMenu.isShow;
	this.createListShow = mainMenu.createListShow;
	this.showSelectLibrary = mainMenu.showSelectLibrary;
	this.showFeedback = mainMenu.showFeedback;
	this.showLinkAccount = mainMenu.showLinkAccount;
	this.isLinkAccountAvailable = mainMenu.isLinkAccountAvailable;
	this.isCreateListShow = mainMenu.isCreateListShow;
	this.showCreateLibrary = mainMenu.showCreateLibrary;
	this.showCreateSection = mainMenu.showCreateSection;
	this.trigger = mainMenu.trigger;

	this.authorization = authorization;
    this.selectLibrary = selectLibrary;
});
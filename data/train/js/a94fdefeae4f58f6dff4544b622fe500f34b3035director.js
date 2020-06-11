/*
 * 	@author Tapani Jamsa
 */

Director = function() {

	this.setScreen(DirectorScreens.menu);
};

DirectorScreens = {
	menu: 0,
	setup: 1,
	roomBrowser: 2,
	lobby: 3,
	controls: 4,
	game: 5,
	gameMenu: 6,
	gameover: 7
};

Director.prototype.setScreen = function(newScreen) {
	if (this.screen != newScreen) {
		// *hide previous screen items
		$("#onlineButton").hide();
		$("#offlineButton").hide();
		$("#title").hide();
		$("#okButton").hide();
		$("#helpOnline").hide();
		$("#helpOffline").hide();
		$("#gameMenuButton").hide();
		$("#infoButton").hide();
		$("#continueButton").hide();
		$("#replayButton").hide();
		$("#menuButton").hide();
		$("#playersInfo").hide();


		this.currentScreen = newScreen;

		switch (this.currentScreen) {
			case 0: // MENU
				// *show title*
				// *show play button*
				// *show info button*
				// *show volume button*
				$("#onlineButton").show();
				$("#offlineButton").show();
				$("#title").show();
				$("#infoButton").show();

				break;
			case 1: //  SETUP
				// *show setup*
				// *show ok button*
				break;
			case 2: //  ROOM BROWSER
				// *show rooms*
				// *show scrollbar*
				break;
			case 3: //  LOBBY
				// *show chat*
				// *show ready button*
				break;
			case 4: //  CONTROLS
				// *show controls*
				// *show ok button*
				console.log("controls");

				$("#okButton").show();

				if (p2pCtrl.netRole === null) {
					$("#helpOffline").show();
					gui.open();
				} else {
					$("#helpOnline").show();
					gui.close();
				}
				break;
			case 5: //  GAME SCENE
				// *generate scene*
				// *show game menu button*
				// *show mini chat*
				// *show players infos

				$("#gameMenuButton").show();

				// Player names and ball counts
				$("#playersInfo").show();



				// generateScene();


				break;
			case 6: //  GAME MENU (pause)
				// *show volume button*
				// *show game menu button*
				// *show menu button*
				// *show replay button *
				// *show continue button *
				$("#infoButton").show();
				$("#continueButton").show();
				$("#replayButton").show();
				$("#menuButton").show();


				break;
			case 7: //  GAME OVER
				// *show game over window*
				// *show ok button*
				break;
		}
	} else {
		console.log("screen already set");
	}
};

Director.prototype.doNextScreen = function() {
	this.setScreen(this.currentScreen + 1);
};
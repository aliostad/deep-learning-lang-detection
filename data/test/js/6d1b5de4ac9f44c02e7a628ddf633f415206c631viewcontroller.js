define(['lib/jquery'], function ($$dummy1) {
	var currentview = "loadingview";

	$("#btnSettings").on("click", function (eventObject) {
		ShowSettings();
	});

	$("#btnLibrary").on("click", function (eventObject) {
		ShowArtistView();
	});

	function ShowCurrentView() {
		$("div#mainview>div").addClass("invisible");
		$("div#" + currentview).removeClass("invisible");
	}

	function ShowArtistView() {
		currentview = "artistview";
		ShowCurrentView();
	}

	function ShowAlbumView() {
		currentview = "albumview";
		ShowCurrentView();
	}

	function ShowTrackView() {
		currentview = "trackview";
		ShowCurrentView();
	}

	function ShowSettings() {
		currentview = "settingsview";
		ShowCurrentView();
	}

	function ShowFolderPicker() {
		currentview = "libraryDirPicker";
		ShowCurrentView();
	}

	return {
		ShowArtistView: ShowArtistView,
		ShowAlbumView: ShowAlbumView,
		ShowTrackView: ShowTrackView,
		ShowSettings: ShowSettings,
		ShowFolderPicker: ShowFolderPicker,
		getCurrentView: function () { return currentview; }
	}
});
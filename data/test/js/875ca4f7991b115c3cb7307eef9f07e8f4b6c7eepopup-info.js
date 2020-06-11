(function () {
	"use strict";

	var innovation = window.innovation = window.innovation || {};
	innovation.popupinfo = innovation.popupinfo || {};

	var STORAGE_SHOW = "show_popupinfo";

	innovation.popupinfo.start = function () {
		var showPopup = localStorage.getItem(STORAGE_SHOW);
		console.log("innovation.popupinfo.start: " + showPopup);
		if (showPopup !== "false") {
			innovation.view.showInfoPopup();
		}
	};

	innovation.popupinfo.remove = function (active) {
		localStorage.setItem(STORAGE_SHOW, false);
	};

})();
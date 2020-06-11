var notification = function(p) {
	function showMessage(text, clss) {
		p(".msg").remove();
		var clss = clss + " msg";
		var div = $("<div/>").addClass(clss).text(text);
		p("body").append(div);
	}
	function showWarning(text) {
		return showMessage(text, "warning");
	}
	function showError(text) {
		return showMessage(text, "error");
	}
	function showInfo(text) {
		return showMessage(text, "info");
	}
	return {
		showWarning: showWarning,
		showError: showError,
		showInfo: showInfo
	};
}($);

$("#warning-button").click(function() {
	notification.showWarning("warning");
});

$("#error-button").click(function() {
	notification.showError("error");
});

$("#info-button").click(function() {
	notification.showInfo("info");
});
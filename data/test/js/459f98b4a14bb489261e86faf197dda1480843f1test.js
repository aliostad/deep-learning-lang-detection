window.onload = function() {
	
	var isIE = /*@cc_on!@*/0;
	
	var css = {
		showBtn: "show",
		hideBtn: "hide",
		showWithStatusBtn: "showWithStatus",
		showWithStatusInput: "showWithStatusInput"
	}
	var showBtn = document.getElementsByClassName(css.showBtn)[0],
		hideBtn = document.getElementsByClassName(css.hideBtn)[0],
		showWithStatusBtn = document.getElementsByClassName(css.showWithStatusBtn)[0],
		showWithStatusInput = document.getElementsByClassName(css.showWithStatusInput)[0];
	
	var showBtnHandler = function(e) {
		HUD.show();
	}
	
	var hideBtnHandler = function(e) {
		HUD.dismiss();
	}
	
	var showWithStatusBtnHandler = function(e) {
		var value = showWithStatusInput.value;
		HUD.show({
			text: value
		});
	}
	
	showBtn.addEventListener("click", showBtnHandler);
	hideBtn.addEventListener("click", hideBtnHandler);
	showWithStatusBtn.addEventListener("click", showWithStatusBtnHandler);
}
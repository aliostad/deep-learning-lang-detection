function show(message){
	$("#message").html(message);
	$("#message").slideDown("medium").delay(2500).slideUp();
}

function showWarning(message) { // yellow
	$("#message").hide();
	$("#message").css("background", 'yellow');
	show(message);
}

function showError(message) { // RED
	$("#message").hide();
	$("#message").css("background", '#F00B42');
	show(message);
}

function showSuccess(message) { // GREEN
	$("#message").hide();
	$("#message").css("background", '#02AC1E');
	show(message);
}

function showMessage(message) { // blue
	$("#message").hide();
	$("#message").css("background", '#A8BEE3');
	show(message);
}

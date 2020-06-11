$(function() {
	$("#add-service").show(1000);
	$("#edit-service").hide();
	$("#remove-service").hide();
});
function handleVisibility(selected) {
	if (selected === 'add') {
		$("#add-service").show(1000);
		$("#edit-service").hide(1000);
		$("#remove-service").hide(1000);
	} else if (selected === 'edit') {
		$("#add-service").hide(1000);
		$("#edit-service").show(1000);
		$("#remove-service").hide(1000);
	} else if (selected === 'remove') {
		$("#add-service").hide(1000);
		$("#edit-service").hide(1000);
		$("#remove-service").show(1000);
	}
}
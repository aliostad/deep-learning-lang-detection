$(function() {
	$('#newMessageContent').click(function() {
		document.newMessage.newMessageContent.value = "";
	});
	
	$('#newMessageSend').click(function() {
		var username = $("#loggedUser").html();
		var message = $("#newMessageContent").val();
		
		if (message == "" || message == "Enter your message here") {
			return false;
		}
		
		var dataString = 'username=' + username + '&message=' + message;
		
		$.ajax({
			type: "POST",
			url: "send_message.php",
			data: dataString,
			success: function() {
				document.newMessage.newMessageContent.value = "";
			}
		});		
	});
});
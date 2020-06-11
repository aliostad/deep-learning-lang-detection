// EVENTS
$('#message').on('keyup', function(event) {
	if(event.charCode == 13) {
		submitMessage();
	}
});

$('#send').on('click', submitMessage);

// FUNCTIONS
function submitMessage() {
	var $input = $('#message');
	var message = $input.val();
	if(!message == "") {
		socket.emit('chat message', message); // emits a chat message event to the server
	}
	$input.val('');
	return false;
};

function addMessage(msg) {
	var message = $('<li>').text(msg);
	$('#messages').append(message);
	$('#chat').scrollTop($('#chat')[0].scrollHeight);
};


// SOCKET EVENTS
socket.on('add chat message', addMessage);
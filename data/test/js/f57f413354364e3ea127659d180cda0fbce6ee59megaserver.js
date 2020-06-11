function connect_callback() {
	send_post_request('connect', $('#baudrate').val(), dummy_callback)
}

function create_message(message_type, message_content) {
	var message = new Object()
	message.command = message_type
	message.content = message_content
	return message
}

function send_post_request(request_type, message_content, callback_function) {
	var message = create_message(request_type, message_content)
	var request = $.ajax({
		url: 'http://127.0.0.1:8080',
		type: 'POST',
		data: JSON.stringify(message, null, 4),
		dataType: 'json'
	})
	request.done(callback_function)	
}

function dummy_callback(message) {
	alert(message)
}

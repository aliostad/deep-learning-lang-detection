var socket = io.connect('http://localhost');

$( window ).load( function ()
{
	var messageInput	= $( '.user-message' );
	var messageButton	= $( '.send-message' );
	var messageList		= $( '.message-list' );

	function addMessage( data )
	{
		var user = data.user || 'Me';
		var messageLi	= $( '<li>' + user + '[' + data.date + '] : ' + data.content + '</li>' );
		messageList.append( messageLi );
	}

	socket.on( 'message:sent', function (data)
	{
		console.log( 'message sent' );
		var lastMessage = messageList.last().html();
		messageList.last().html( lastMessage + ' ✓' );
	} );

	socket.on( 'message:broadcast', function (data)
	{
		addMessage( data );
	} );

	messageButton.click( function ( e )
	{
		var messageData =
		{
			date : new Date(),
			content : messageInput.val()
		};

		addMessage( messageData );

		socket.emit( 'message', messageData );
	} );

} );

	function Message( sender, reciever, subject, message){
        this.sender = sender;
        this.reciever = reciever;
        this.subject = subject;
        this.message = message;
    }

    function sendMessage( messageObject ){
    	$('#subjectMessage').val('');
    	$('#messageText').val('');
    	console.log(messageObject);
    }


    $(document).ready(function() {

	    $('#sendMessageButton').bind('click', function() {
			var messageObject = new Message( window.myFamily.dbID, 
											 window.selectedContact.dbID,
											 $('#subjectMessage').val(),
											 $('#messageText').val()
										   )
			sendMessage(messageObject);
		});
	});

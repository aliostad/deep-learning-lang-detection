var message_delay = 4000;

$(document).ready(function() 
{
    $('#close-message-btn').on('click', closeMessage);

    var message = $('#user_message').text().trim();

    if(message.length > 0)
	{
		showMessageField();
	}
});

function showSuccess(successText) 
{
	showMessage(successText, 'panel-success');
}

function showError(errorText) 
{
	showMessage(errorText, 'panel-danger');
}

function showWarning(warningText)
{
	showMessage(warningText, 'panel-warning');
}

function showMessage(message, panelType) 
{
	$('#user_message').text('');
	if(message.length > 128)
	{
		message = message.substr(0, 125);
		message += '...';
	}

	$('#message_field').removeClass('panel-success');
	$('#message_field').removeClass('panel-warning');
	$('#message_field').removeClass('panel-danger');

	$('#message_field').addClass(panelType);

	$("html, body").animate({ scrollTop: 0 }, "fast");
	showMessageField(message);
}

function showMessageField(message)
{
    $('#message_field').slideDown(400, function(){
        if(message) 
        {
            $('#user_message').text(message);
		    console.log(message);
        }
		$('#message_field').delay(message_delay).slideUp();
	});
}

function closeMessage()
{
	$('#message_field').clearQueue().slideUp(400, function(){	
	});
}
function MessageBox() 
{
}

MessageBox.ALERT = 'alert';
MessageBox.PROMPT = 'prompt';
MessageBox.CONFIRM = 'confirm';

MessageBox.show = function(message, type, defaultMessage)
{
	var t = type == null ? MessageBox.ALERT : type;
	var dm = defaultMessage == null ? '' : defaultMessage;
	var result = null;
	switch(t) {
		case MessageBox.PROMPT : result = prompt(message, dm);
		break;
		case MessageBox.CONFIRM : result = confirm(message);
		break;
		default : alert(message);
	}
	return result;
}

MessageBox.lightBox = function(message, type, defaultMessage)
{
	var t = type == null ? MessageBox.ALERT : type;
	var dm = defaultMessage == null ? '' : defaultMessage;
	var result = null;
	switch(t) {
		case MessageBox.PROMPT : result = MessageBox.lbPrompt(message, dm);
		break;
		case MessageBox.CONFIRM : result = MessageBox.lbConfirm(message);
		break;
		default : MessageBox.lbAlert(message);
	}
	return result;
}

MessageBox.lbAlert = function(message)
{
}

MessageBox.lbPrompt = function(message, defaultMessage)
{
}

MessageBox.lbConfirm = function(message)
{
	
}
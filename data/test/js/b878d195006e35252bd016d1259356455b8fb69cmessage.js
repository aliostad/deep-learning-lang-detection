// Copyright: see COPYING
// Authors: see git-blame(1)

var message_current = false;

function message_update (newtext)
{
    if (!newtext) {
	$('message').style.display='none';
	$('message').update('');
	message_current = false;
    }
    else {
	message_current = { text: newtext };
	$('message').update(newtext.sub(/^<[Pp]>/,"").sub(/<\/[Pp]>$/,""));
	$('message').style.display='block';
    }
}

function message_init()
{
    if ($('message') && $('message').innerHTML) {
	message_current = { text: $('message_init').innerHTML };
    }
}
addEvent(window,'load',message_init);

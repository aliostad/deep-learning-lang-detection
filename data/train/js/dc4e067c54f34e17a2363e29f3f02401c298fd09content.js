var processMessage = function ( message , sender , callback )
{

    // Validate the message sender
    if  ( sender.id !== chrome.runtime.id )
    {
        return;
    }

    // Validate the message type
    var messageType = 'toggle-mute';
    if ( message.type !== messageType )
    {
        return;
    }

    // Send a message
    var message = { type: messageType };
    var messageOrigin = 'https://relaxound.kolyunya.me/';
    window.postMessage(message,messageOrigin);

}

$(window).bind
(
    'message',
    function ( event )
    {
        var message = event.originalEvent.data;
        var messageType = message.type;
        if ( messageType == 'mute-toggled' )
        {
            var mute = message.mute;
            var message =
            {
                type: 'mute-toggled',
                mute: mute,
            };
            chrome.runtime.sendMessage(message);
        }
    }
);

// Listen to the extension messages
chrome.runtime.onMessage.addListener(processMessage);

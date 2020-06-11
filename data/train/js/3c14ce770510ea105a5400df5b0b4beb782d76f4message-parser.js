var Message = require('../models/Message.js');

// message types:
// >>> - outgoing message
// <<< - incoming message
// ««« - incoming message (from history)

var messageType = {
    '>>>': 'outgoing',
    '<<<': 'incoming',
    '«««': 'incoming_history'
};

var messagePattern = /^\[(.*?)\]\s{2}(.*?)\s(>>>|<<<|«««)\s(.+?)$/;
var parseMessage = function(string){
    var result = messagePattern.exec(string);
    
    if(!result) return false;

    return new Message(
        result[1],  //time
        result[2],  //peer
        messageType[result[3]], //type
        result[4]   //body
    );
};

module.exports = parseMessage;

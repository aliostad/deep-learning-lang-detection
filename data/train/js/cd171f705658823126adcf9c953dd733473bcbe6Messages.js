//= game/gamemessage.js
//= lobby/lobbymessage.js

MessageParser = {
    
    split: function(message) {
        if (!message) return null;
        return message.split("|"); 
    },
    
    parse: function(message) {
        var elements = MessageParser.split(message),
            messageType;

        if (elements.length > 0) {
            messageType = parseInt(elements[0]);
            for (var messageCls in Messages) {
                if (Messages[messageCls].messageId == messageType) {
                    return Messages[messageCls].parse(message);
                }
            }
       }
       return null;
    }
}

Messages = {
    GameMessage: GameMessage,
    LobbyMessage: LobbyMessage,
    Parser: MessageParser
};
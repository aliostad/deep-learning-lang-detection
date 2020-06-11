app.factory('chatFactory', function () {
    var messages = [];

    return {
        getMessages: function () {
            return messages;
        },

        addMessage: function (user, message) {
            if(messageNotEmpty(message)){
                var lastMessage = getLastMessage();

                if(isLastUser(lastMessage, user)){
                    continueMessage(lastMessage, message);
                }else{
                    newMessage(user, message);
                }
            }
        }
    };

    function messageNotEmpty (message){
        return message.length != 0;
    }

    function getLastMessage(){
        return messages[messages.length - 1];
    }

    function isLastUser(last, newUser){
        return last && (last.user.id === newUser.id)
    }

    function continueMessage(last, message){
        return last.text += '\n' + message;
    }

    function newMessage(user, message){
        return messages.push({user: user, text: message});
    }
});
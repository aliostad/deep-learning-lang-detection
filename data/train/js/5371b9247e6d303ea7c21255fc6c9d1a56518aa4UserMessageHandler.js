define([], function(){
    function UserMessageHandler(userController){
        this.userController = userController;
        this.handlers = {};

        this.registerHandler = function(messageType, handler){
            if (handler instanceof  UserMessageHandler){
                this.handlers[messageType] = handler;
            }
        };
    }

    UserMessageHandler.prototype.constructor = UserMessageHandler;

    UserMessageHandler.prototype.handle = function(messageData){
        var message = JSON.parse(messageData);
        if (this.handlers.hasOwnProperty(message.messageType)){
            this.handlers[message.messageType].handle(message.messageBody);
        }
    };

    return UserMessageHandler;
});
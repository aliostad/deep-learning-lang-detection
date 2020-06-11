Ext.define("PublicChat.desktop.controller.handlers.CanPrintMessage", function () {

    // Private:
    var getMessage = function (message) {
        message = Ext.create("PublicChat.common.model.Message", {
            username:message.username,
            message:message.message
        });
        return message;
    };

    // Public:
    return {
        printMessage:function (message) {
            var dataMessage = message.data,
                messageGrid;
            if (dataMessage.message !== undefined && dataMessage.username) {
                messageGrid = this.getMessageGrid();
                messageGrid.getStore().add(getMessage(message.data));
                messageGrid.scrollByDeltaY(messageGrid.getEl().getHeight());
            }
        },

        printPrivateMessage:function (message) {
            var dataMessage,
                imMessage,
                username;

            dataMessage = message.data;
            imMessage = dataMessage.message;
            username = dataMessage.username;

            this.printMessage({data:{message:"<span style='color: #ff3c2f;';>" + imMessage + "</span>", username:"<span style='color: #ff3c2f;'>" + username + "</span>"}});
        }
    }

});
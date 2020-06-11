/**
 * Created by Administrator on 9/10/2015.
 */
function printableMessage() {
    var message = "hello";

    function setMessage(newMessage) {
        if (!newMessage) throw new Error('Cannot set empty Message');
        message = newMessage;
    }

    function getMessage() {
        return message;
    }

    function printMessage() {
        console.log(message);
    }

    return {
        setMessage: setMessage,
        getMessage: getMessage,
        printMessage: printMessage
    }
}

var awesome1 = printableMessage();
awesome1.printMessage();

var awesome2 = printableMessage();
awesome2.setMessage('hi');
awesome2.printMessage();

awesome1.printMessage();
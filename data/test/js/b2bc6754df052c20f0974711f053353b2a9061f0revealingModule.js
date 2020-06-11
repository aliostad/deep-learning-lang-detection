function printableMessage() {
    var message = 'hello';
    function setMessage(newMessage) {
        if (!newMessage) throw new Error('cannot set empty message');
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
    };
}

// Pattern in use 
var awesome1 = printableMessage();
awesome1.printMessage(); // hello

var awesome2 = printableMessage();
awesome2.setMessage('hi');
awesome2.printMessage(); // hi

// Since we get a new object everytime we call the module function
// awesome1 is unaffected by awesome2
awesome1.printMessage(); // hello

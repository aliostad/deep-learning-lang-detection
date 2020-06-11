function ExpressionParser() {
    var currentMessage = null;

    var rootMessage = new SyncMessage('root', 'CLIENT', 'whatever');
    var messageStack = [rootMessage];

    function getMessageFromSentence(sentence, from) {
        from = from || '';
        sentence = sentence.split(" ").join("");
        // We expect the invoke as - result=B.MethodB();
        /((\w+)=)*((\w+)\.)*(.+)/.test(sentence);

        var returnResult = RegExp.$2;
        var entityTo = RegExp.$4;
        var message = RegExp.$5;

        if (message.endsWith(';')) {
            message = message.substr(0, message.length - 1);
        }

        var text = "";
        if (returnResult != "") {
            text = "[" + returnResult + "]" + message;
        } else {
            text = message;
        }
        return SyncMessage(from, entityTo, text);
    }


    return {
        parseInvoke:function (expression) {
            expression = expression.trim();
            if (expression === "") return null;

            var message = getMessageFromSentence(expression, messageStack[messageStack.length - 1].to);
            if (message.to === "") message.to = message.from;
            messageStack[messageStack.length - 1].subMessages.push(message);
            currentMessage = message;
        },

        parseUnknown:function () {
            // do nothing
        },

        enter:function () {
            messageStack.push(currentMessage);
        },
        exit:function () {
            messageStack.pop();
        },
        getResult:function () {
            return rootMessage.subMessages;
        }
    }
}

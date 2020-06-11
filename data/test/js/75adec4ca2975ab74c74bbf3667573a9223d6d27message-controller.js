var Message = require('mongoose').model('Message');

module.exports = {
    sendMessage: function (message) {
        var newMessage = new Message({
            from: message.from,
            to: message.to,
            text: message.text
        });

        newMessage.save(function (err, message) {
            if (err) {
                console.log('Creating new message failed: ' + err);
            }
        })
    },
    getAllMessages: function (message, callback) {

        Message.find([{from: message.with, to: message.and},
                     {from: message.and, to: message.with}])
            .exec(function (err, result) {
                if (err) {
                    console.log('Getting all messages failed: ' + err);
                    return;
                }
                callback(result);
            });

    }
};

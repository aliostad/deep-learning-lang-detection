var userController, messageController;

module.exports = {
    init: function (config) {
        require('../config/mongoose')(config);
        userController = require('../controllers/userController');
        messageController = require('../controllers/messageController');
    },
    registerUser: function(user) {
        userController.registerUser(user);
    },
    sendMessage: function(message) {
        messageController.sendMessage(message);
    },
    getMessages: function(message) {
        messageController.getMessageBetweenUsers(message, function (messages) {
            console.log(messages.join('\n\n'));
        });
    }
};
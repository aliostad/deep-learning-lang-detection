module.exports = {

    attributes: {

        content: 'STRING',
        createTime: 'FLOAT',
        toUser: 'STRING',
        fromUser: 'STRING',
        messageType: 'STRING',
        messageId: 'FLOAT'
    },

    /**
     * 判断消息是否是通知消息
     * @param string
     * @returns {boolean}
     */
    isValidNoticeMessage: function (message) {
        return new RegExp('^[+]{1}[^+-]*$').test(message.Content);
    },
    /**
     * 将普通文本消息改为通知类消息
     * @param messageId
     */
    changeToNotice: function (messageId) {
        Message.update({
            _id: messageId
        }, {
            messageType: 'notice'
        }, function (err, message) {
            if (err) {
                return console.log(err);
            } else {
                console.log("Message updated:", message);
                return message;
            }
        });
    },
    isValidNormalMessage: function (message) {
        return new RegExp('^[-]{1}[^-+]*$').test(message.Content);
    },
    isValidMessage: function (message) {
        return this.isValidNormalMessage(message) || this.isValidNoticeMessage(message);
    }

};
import client from 'socket.io-client';

const INTERNAL_MESSAGES = {
    disconnect: true,
};

export default class ClientNetworkManager {
    constructor(host) {
        this.socket = client.connect(host, {
            'reconnect': false
        });
    }

    sendMessage(message) {
        this.socket.emit(message.constructor.getMessageName(), message.getMessagePayload());
    }

    on(messageClass, callback) {
        this.socket.on(messageClass.getMessageName(), (messageData) => {
            // If internal, socket io generates messageData and it won't be 'applyable' by default
            if (this.isInternal(messageClass.getMessageName())) {
                messageData = [messageData];
            }

            const message = Object.create(messageClass.prototype);
            messageClass.apply(message, messageData);

            callback.call(this, message);
        })
    }

    isInternal(messageName) {
        return INTERNAL_MESSAGES[messageName];
    }
}

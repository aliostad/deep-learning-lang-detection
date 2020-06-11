const Message = require('model/message');

class MessageService {

    constructor() {
        console.log('MessageService initialize...');
    }

    save(message) {
        return new Message(message).save(message);
    }

    retrive(query) {
        return Message.find()
            .sort(query.sort)
            .skip(query.skip)
            .limit(query.limit)
            .exec();
    }

    retriveById(id) {
        return Message.findById(id);
    }

    deleteById(id) {
        return Message.findByIdAndRemove(id);
    }

}

module.exports = MessageService;
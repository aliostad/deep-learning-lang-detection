var mongoose = require('mongoose');

// validates message length
var messageValidator = function(message) {
    return message.length > 0 && message.length < 200;
};

// Schema for a message - a simple <200 character post.
var messageSchema = mongoose.Schema({
    message : {type: String,  required : true, validator : messageValidator},
    user : {
        username : {type: String, required : true},
        _id : {type : mongoose.Schema.Types.ObjectId, required : true}
    },
    dateAdded : {type: Date, default: Date.now()}
});

messageSchema.pre('save', function(next) {
    var message = this;
    return next();
});

exports.messageSchema = messageSchema;
exports.Message = mongoose.model('Message', messageSchema);
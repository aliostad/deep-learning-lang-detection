var moongose =require('mongoose');
var Schema =require('./mongoSchema');
var Message=moongose.model('Message',Schema.messageSchema);
var Comment=moongose.model('Comment',Schema.commentSchema);
var User=moongose.model('User',Schema.userSchema);

var Models ={

    MessageModel :Message,
    CommentModel :Comment,
    UserModel :User
}

module.exports =Models;

/*var messageInsert=new Message(
    {
        messageType :'T',
        messageData :'xxx',
        messageLikes:0,
        messagePostedDate :new Date()
    }
)

messageInsert.save(function(err,data)
    {
        console.log("data inserted");

    }
)*/

/*
Message.findById({"_id" : "55f824a863b9c6601cac0f6d"},function(err,message)
    {
message.messageLikes=message.messageLikes+1;
        message.save(function(err,data)
            {
                console.log("Updated successfully")
            }
        )
    }
)*/

/*
Message.update({"_id" : "55f824a863b9c6601cac0f6d"},{$set:{messageType:'F'}},function(err,data)
{
    console.log("Updated successfully")
});*/

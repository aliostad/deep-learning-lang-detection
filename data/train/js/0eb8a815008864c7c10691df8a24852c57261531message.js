'use strict';
var messageModel = require('..//models/message');
var messageRoomModel = require('..//models/messageRoom');

var Message = messageModel.Message;
var MessageRoom = messageRoomModel.MessageRoom;

var messageController = {
    getMessages: getMessages,
    createMessage: createMessage
    
};

function getMessages(req, res) {
        var queryObj = {};
        let selectString = 'anonName picture';
        queryObj.messageRoom = req.params.roomID;
        var options ={};
        options.limit = 50;//req.query.limit ? parseInt(req.query.limit) : 50;
        options.sort = {
            time: -1
        };
        options.page = req.query.page || 1;
        options.populate=[{ path: 'user', select: selectString, model: 'User' }];
        Message.paginate(queryObj,options).then(function(messages){
            return res.json(messages);
        }).catch(function(e){
            console.log("Error in getMessages");
            console.log(e);
        });
    }
    

function createMessage(req, res) {
    
        var recData = req.body;
        
        var message = new Message();
        
        message.user = req.user;    
        message.type = recData.type;
        
        message.messageRoom = req.params.roomID;
        message.message = recData.message;
        
        message.save().then(function(savedMessage) {
            saveMessageRoom({_id:savedMessage.messageRoom},savedMessage);
            sendMessage(req,res,savedMessage);
            res.json({savedMessage:savedMessage});
        }).catch(function(e){
            console.log("error in message save");
            console.log(e);
        });
}


function saveMessageRoom(queryObj,message,callback){
    
    MessageRoom.findOne(queryObj,function(err1,messageRoom){
        
        if(err1){
            console.log("err 89");
            console.log(err1);
            //return res.send({"message":err1});
        }
        
        
        messageRoom.lastMessage = message;
        messageRoom.lastMessageTime = message.time;
        messageRoom.save(function(err,messageRoomSaved){
            if(err){
                console.log(err);
            }
            
            if(callback){
                callback(messageRoomSaved);    
            }
            
        });
    });
}

function sendMessage(req,res,message){
    Message.populate(message, { path: "user",model:'User', select: 'anonName picture'}, function(err, popMessage) {
        if(err){
            console.log(err);
            return res.json({message:err});
        }
        req.io.to(message.messageRoom).emit('roomMessageReceived',popMessage);
    });
    
}
module.exports = messageController;
    
    
    
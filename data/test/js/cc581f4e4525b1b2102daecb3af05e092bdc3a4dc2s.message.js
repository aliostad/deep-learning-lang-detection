var message = require('./odin.message.js');
var entity = require('./chat.entity.js');
var moment = require('moment');


var HeartbeatMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
};
HeartbeatMessage.prototype = new message.Message();
HeartbeatMessage.prototype.constructor = HeartbeatMessage;

exports.HeartbeatMessage = HeartbeatMessage;

var ReqLoginMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.dummy = undefined;
};
ReqLoginMessage.prototype = new message.Message();
ReqLoginMessage.prototype.constructor = ReqLoginMessage;

exports.ReqLoginMessage = ReqLoginMessage;

var ReqLogoutMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
};
ReqLogoutMessage.prototype = new message.Message();
ReqLogoutMessage.prototype.constructor = ReqLogoutMessage;

exports.ReqLogoutMessage = ReqLogoutMessage;

var ReqJoinMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.group = undefined;
};
ReqJoinMessage.prototype = new message.Message();
ReqJoinMessage.prototype.constructor = ReqJoinMessage;

exports.ReqJoinMessage = ReqJoinMessage;

var ReqLeaveMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.group = undefined;
};
ReqLeaveMessage.prototype = new message.Message();
ReqLeaveMessage.prototype.constructor = ReqLeaveMessage;

exports.ReqLeaveMessage = ReqLeaveMessage;

var ReqUserListMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.group = undefined;
};
ReqUserListMessage.prototype = new message.Message();
ReqUserListMessage.prototype.constructor = ReqUserListMessage;

exports.ReqUserListMessage = ReqUserListMessage;

var ReqChatMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.group = undefined;
	this.chat = undefined;
};
ReqChatMessage.prototype = new message.Message();
ReqChatMessage.prototype.constructor = ReqChatMessage;

exports.ReqChatMessage = ReqChatMessage;


var message = require('./odin.message.js');
var entity = require('./chat.entity.js');
var moment = require('moment');


var ResLoginMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.isOk = undefined;
	this.errorMessage = undefined;
	this.publicIp = undefined;
	this.publicPort = undefined;
	this.dummy = undefined;
};
ResLoginMessage.prototype = new message.Message();
ResLoginMessage.prototype.constructor = ResLoginMessage;

exports.ResLoginMessage = ResLoginMessage;

var ResLogoutMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.isOk = undefined;
	this.errorMessage = undefined;
};
ResLogoutMessage.prototype = new message.Message();
ResLogoutMessage.prototype.constructor = ResLogoutMessage;

exports.ResLogoutMessage = ResLogoutMessage;

var ResJoinMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.isOk = undefined;
	this.errorMessage = undefined;
};
ResJoinMessage.prototype = new message.Message();
ResJoinMessage.prototype.constructor = ResJoinMessage;

exports.ResJoinMessage = ResJoinMessage;

var NotifyJoinMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.group = undefined;
	this.publicIp = undefined;
	this.publicPort = undefined;
};
NotifyJoinMessage.prototype = new message.Message();
NotifyJoinMessage.prototype.constructor = NotifyJoinMessage;

exports.NotifyJoinMessage = NotifyJoinMessage;

var ResLeaveMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.isOk = undefined;
	this.errorMessage = undefined;
};
ResLeaveMessage.prototype = new message.Message();
ResLeaveMessage.prototype.constructor = ResLeaveMessage;

exports.ResLeaveMessage = ResLeaveMessage;

var NotifyLeaveMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.group = undefined;
};
NotifyLeaveMessage.prototype = new message.Message();
NotifyLeaveMessage.prototype.constructor = NotifyLeaveMessage;

exports.NotifyLeaveMessage = NotifyLeaveMessage;

var ResUserListMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.userList = undefined;
};
ResUserListMessage.prototype = new message.Message();
ResUserListMessage.prototype.constructor = ResUserListMessage;

exports.ResUserListMessage = ResUserListMessage;

var ResChatMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.isOk = undefined;
	this.errorMessage = undefined;
};
ResChatMessage.prototype = new message.Message();
ResChatMessage.prototype.constructor = ResChatMessage;

exports.ResChatMessage = ResChatMessage;

var NotifyChatMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.chat = undefined;
};
NotifyChatMessage.prototype = new message.Message();
NotifyChatMessage.prototype.constructor = NotifyChatMessage;

exports.NotifyChatMessage = NotifyChatMessage;


var message = require('./message.js');
var entity = require('./entity.js');
var moment = require('moment');


var ResLoginMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.is_ok = undefined;
	this.error_msg = undefined;
	this.public_ip = undefined;
	this.public_port = undefined;
};
ResLoginMessage.prototype = new message.Message();
ResLoginMessage.prototype.constructor = ResLoginMessage;

exports.ResLoginMessage = ResLoginMessage;

var ResLogoutMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.is_ok = undefined;
	this.error_msg = undefined;
};
ResLogoutMessage.prototype = new message.Message();
ResLogoutMessage.prototype.constructor = ResLogoutMessage;

exports.ResLogoutMessage = ResLogoutMessage;

var ResJoinMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.is_ok = undefined;
	this.error_msg = undefined;
};
ResJoinMessage.prototype = new message.Message();
ResJoinMessage.prototype.constructor = ResJoinMessage;

exports.ResJoinMessage = ResJoinMessage;

var NotifyJoinMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.group = undefined;
	this.public_ip = undefined;
	this.public_port = undefined;
};
NotifyJoinMessage.prototype = new message.Message();
NotifyJoinMessage.prototype.constructor = NotifyJoinMessage;

exports.NotifyJoinMessage = NotifyJoinMessage;

var ResLeaveMessage = function() {
	message.Message.apply(this, arguments);
	this.uid = undefined;
	this.is_ok = undefined;
	this.error_msg = undefined;
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
	this.user_list = undefined;
};
ResUserListMessage.prototype = new message.Message();
ResUserListMessage.prototype.constructor = ResUserListMessage;

exports.ResUserListMessage = ResUserListMessage;


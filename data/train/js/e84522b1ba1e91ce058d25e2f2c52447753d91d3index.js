var server = require("./server");
var router = require("./router");
var serverAPI = require("./serverAPI");
var clientAPI = require("./clientAPI");

var handle = {}

// 商户平台API
handle["/login"] = serverAPI.login;
handle["/getroom"] = serverAPI.getRoom;
handle["/getroomstatus"] = serverAPI.getRoomStatus;
handle["/responsebell"] = serverAPI.responseBell;
handle["/clearroom"] = serverAPI.clearRoom;

// 客户端API
handle["/userlogin"] = clientAPI.userlogin;
handle["/announce"] = clientAPI.announce;
handle["/gotoroom"] = clientAPI.gotoroom;
handle["/exitroom"] = clientAPI.exitroom;
handle["/shop"] = clientAPI.shop;
handle["/bell"] = clientAPI.bell;
handle["/unreadmessage"] = clientAPI.unreadmessage;
handle["/readmsg"] = clientAPI.readmsg;
handle["/rate"] = clientAPI.rate;
handle["/updatenick"] = clientAPI.updatenick;

server.start(router.route, handle);

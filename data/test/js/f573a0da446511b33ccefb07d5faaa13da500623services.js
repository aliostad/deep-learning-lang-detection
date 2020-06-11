function __export(m) {
    for (var p in m) if (!exports.hasOwnProperty(p)) exports[p] = m[p];
}
var MessagesService_1 = require("./MessagesService");
var ThreadsService_1 = require("./ThreadsService");
var UserService_1 = require("./UserService");
__export(require("./MessagesService"));
__export(require("./ThreadsService"));
__export(require("./UserService"));
exports.servicesInjectables = [
    MessagesService_1.messagesServiceInjectables,
    ThreadsService_1.threadsServiceInjectables,
    UserService_1.userServiceInjectables
];

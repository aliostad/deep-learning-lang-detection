importScripts('/js/q.js');
function progress(data) {
    var message = {};
    message.type = "progress";
    message.data = data;
    postMessage(message);
}
function success(data) {
    var message = {};
    message.type = "success";
    message.data = data;
    postMessage(message);
}
function error(data) {
    var message = {};
    message.type = "error";
    message.data = data;
    postMessage(message);
}
function copyObj(obj) {
    // Quick and dirty method to copy objects
    return JSON.parse(JSON.stringify(obj));
}

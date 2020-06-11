/// <reference path="JQuery.js" />
$.fn.messageBox = function () {
    var messageBox = $("<div></div>").hide();
    this.append(messageBox);
    messageBox.success = function (message) {
        messageBox.text(message).css("background-color", "green");
        messageBox.fadeIn(1000);
        window.setTimeout( function () {
            messageBox.fadeOut();
        },4000);
    }
    messageBox.error = function (message) {
        messageBox.text(message).css("background-color", "red");
        messageBox.fadeIn(1000);
        window.setTimeout(function () {
            messageBox.fadeOut();
        }, 4000);
    }
    return messageBox;
}
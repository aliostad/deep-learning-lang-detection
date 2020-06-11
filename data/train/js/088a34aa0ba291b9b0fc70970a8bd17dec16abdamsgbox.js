/**
 * msgbox.js
 */

function messageBox(type, message, title) {

    var msg = "[ " + type.toUpperCase() + " ] " + message;
    alert(msg)
}

function confirmationBox(message, title) {
    title = title || "Confirmation";
    confirm(message);
}

function inputBox(message, title, defvalue) {
    title = title || "Confirmation";
    defvalue = defvalue || "";
    prompt(message, defvalue);
}

function errorBox(message, title) {
    title = title || "Error";
    messageBox("error", message, title);
}

function infoBox(message, title) {
    title = title || "Info";
    messageBox("info", message, title);
}

function warningBox(message, title) {
    title = title || "Warning";
    messageBox("warning", message, title);
}
.pragma library

var messages;
var quickMessages;
var lastMessage;
var lastQuickMessage;

function initialize()
{
    lastMessage = null;
    lastQuickMessage = null;
    messages = new Array();
    quickMessages = new Array();
}

function addQuickMessage(message)
{
    quickMessages.push(message)
}

function addMessage(message)
{
    messages.push(message);
}

function getNextMessage()
{
    lastMessage = messages.shift();
    return lastMessage;
}

function getNextQuickMessage()
{
    lastQuickMessage = quickMessages.shift();
    return lastQuickMessage;
}

function nextMessage()
{
    return !(messages.length === 0)
}

function nextQuickMessage()
{
    return !(quickMessages.length === 0)
}

function getLastMessage()
{
    return lastMessage;
}

function getLastQuickMessage()
{
    return lastQuickMessage;
}

var client = new Faye.Client('/faye');

var $messages = $('#messages');
var $messageAuthor = $('#message-author');
var $messageInput = $('#message-input');
var $submitMessage = $('#submit-message');

var subscription = client.subscribe('/messages', function(message) {
  addMessage(message);
});

$submitMessage.on('click', sendMessage);
$messageInput.on('keypress', function (event) {
  if (event.keyCode === 13) sendMessage();
});

function sendMessage() {
  var message = {author: $messageAuthor.val(), body: $messageInput.val()};
  if (!messageParametersAreValid(message)) {
    return alert('You must provide a name and message.');
  }
  client.publish('/messages', message);
  $messageInput.val('').focus();
}

function messageParametersAreValid(message) {
  return message.author && message.body;
}

function addMessage(message) {
  $(['<div class="message">',
     '<span class="message-author">', message.author, '</span>: ',
     message.body,
   '</div>'].join('')).appendTo($messages);
}
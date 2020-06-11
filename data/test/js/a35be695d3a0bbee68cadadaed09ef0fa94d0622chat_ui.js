var socket = io();

var chat = new Chat(socket);

function getMessage () {
  var msg = $('.message-input').val();
  return msg;
};

function sendMessage (message) {
  chat.sendMessage(message);
};

function displayMessage (message) {
  var $msgSpan = $('.message-display');
  var $newLine = $('<span>').text(message);
  $msgSpan.append($newLine);
  $msgSpan.append('<br>');
};

$(function () {
  socket.on('message', function (message) {
    displayMessage(message);
  });

  $(".message-input-form").on("submit", function () {
    event.preventDefault();

    var msg = getMessage();
    $('.message-input').val('');
    sendMessage(msg);
  });
});


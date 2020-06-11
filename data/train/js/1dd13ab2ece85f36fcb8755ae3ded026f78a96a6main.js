$(document).ready(function() {

var previousMessage = '';

  function messagePoll() {
    $.getJSON('/lastmessage', function (result) {
      
      var message = result.page.message;

      $('#messages').removeClass('messagesanimation');

      if ( message != previousMessage ) {
        $('#messages').addClass('messagesanimation');
        $('#messages .message').html(message);
        
        previousMessage = message;
        console.log(message);
      }

    });
  };

  setInterval(messagePoll, 5000);
  messagePoll();

});
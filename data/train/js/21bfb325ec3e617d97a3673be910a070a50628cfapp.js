var main = function() {
    var messages = ["If", "a", "six", "turned", "out", "to", "be", "nine"];

    var displayMessage = function(messageIndex) {

        var $message = $("<p>").text(messages[messageIndex]).hide();

        $(".message").empty();

        $(".message").append($message);

        $message.fadeIn();

        setTimeout(function() {
            messageIndex = (messageIndex + 1) % messages.length;
            displayMessage(messageIndex);
        }, 1000);
    };
  displayMessage(0)
};
$(document).ready(main);
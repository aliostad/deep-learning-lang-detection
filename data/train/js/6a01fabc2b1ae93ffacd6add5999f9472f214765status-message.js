oer.status_message = {};

oer.status_message.message = function(message, _class, autohide) {
  var $message = $('<div class="status-message"></div>').text(message).addClass(_class).hide().prependTo("#status-messages").fadeIn(300);
  if (autohide !== undefined && autohide) {
    setTimeout(function() {
      $message.fadeOut(300);
    }, 5000);
  }
};

oer.status_message.success = function(message, autohide) {
  oer.status_message.message(message, "success", autohide);
};

oer.status_message.error = function(message, autohide) {
  oer.status_message.message(message, "error", autohide);
};

oer.status_message.clear = function() {
  $("#status-messages").empty();
}

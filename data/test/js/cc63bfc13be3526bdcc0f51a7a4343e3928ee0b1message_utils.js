var MessageUtils = {

  display_new_message: function(message_html, message_id) {
    var message_list_item = $("li.message:first-child");
    var message = $(message_html).data("message_id", message_id);
    if (message_list_item[0]) {
      message_list_item.before(message);
    } else {
      $("ul#message_list").html(message);
    }
  },

  display_message: function(message_html, message_id) {
    var message_list_item = $("li.message:last-child");
    var message = $(message_html).data("message_id", message_id);
    if (message_list_item[0]) {
      message_list_item.after(message);
    } else {
      $("ul#message_list").html(message);
    }
  },

  find_message: function(message_id) {
    var message = 0;
    $("#message_list li.message").each(function(index) {
      if ($(this).data("message_id") == message_id) {
        message = $(this);
      }
    });
    return message;
  },

  show_message_loading_icon: function() {
    $('#message_loading_icon').show();
  },

  hide_message_loading_icon: function() {
    $('#message_loading_icon').hide();
  }
};

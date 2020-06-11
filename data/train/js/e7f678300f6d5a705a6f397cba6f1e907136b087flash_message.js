window.onload=function() {
  var flash_message = function (message) {
    var flash_message_box = $('#flash_message_box');
    if (flash_message_box.length === 0) {
      flash_message_box = document.createElement("div");
      flash_message_box.setAttribute("id", "flash_message_box");
      flash_message_box.setAttribute("class", "alert alert-info");
      document.body.appendChild(flash_message_box);
      flash_message_box = $('#flash_message_box');
    }
    flash_message_box.html(message);
    flash_message_box.show();
    flash_message_box.fadeOut(6000);
  };
  document.flash_message = flash_message;
};
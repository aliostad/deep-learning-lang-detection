var url_image_regexp = new RegExp(/[.](gif|jpg|jpeg|png)([?].*)?$/gi);
chat_system.on_new_message(function(chunked_message){
  for(var i = 0; i < chunked_message.length; i++){
    if(chunked_message[i].message_formatter != "url"){
      continue;
    }

    if(chunked_message[i].url.match(url_image_regexp)){
      chunked_message[i].message_formatter = "url_image";
      chunked_message[i].message = "<a href=\"" + chunked_message[i].url + "\" target=\"_blank\"><img src=\"" + chunked_message[i].url + "\" /></a>";
    }
  }
  return chunked_message;
});

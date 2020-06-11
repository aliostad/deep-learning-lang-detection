Solstice.Message = {};
Solstice.Message.current_fade = null;

Solstice.Message.clear = function() {
    Solstice.Message._init();

    $("#sol_message_container").hide();
    $("#sol_message_wrapper").removeClass("sol-message-error");
    $("#sol_message_wrapper").removeClass("sol-message-information");
    $("#sol_message_wrapper").removeClass("sol-message-warning");
    $("#sol_message_wrapper").removeClass("sol-message-success");
    $("#sol_message").html("");

}

Solstice.Message.setError = function(message){
    Solstice.Message.clear();
    Solstice.Message._show("error", message);
}
Solstice.Message.setInfo = function(message){
    Solstice.Message.clear();
    Solstice.Message._show("information", message);
}
Solstice.Message.setWarning = function(message){
    Solstice.Message.clear();
    Solstice.Message._show("warning", message);
}
Solstice.Message.setSuccess = function(message){
    Solstice.Message.clear();
    Solstice.Message._show("success", message);
}

Solstice.Message._show = function(type, message) {
    if (Solstice.Message.current_fade) {
        window.clearTimeout(Solstice.Message.current_fade);
    }
    $("#sol_message_wrapper").addClass("sol-message-"+type);
    $("#sol_message").html(message);

    $("#sol_message_container").css("left", -100000);
    $("#sol_message_container").show();

    $("#sol_message_container").css("left", ($("body").width() - $("#sol_message").width()) / 2);
    $("#sol_message_container").show();

    Solstice.Message.current_fade = window.setTimeout(function() {
        $("#sol_message_container").fadeOut();
    }, 5000);
}

Solstice.Message._init = function() {
    if (!$("#sol_message_container").length) {
        $("body").append("<div id='sol_message_container' style='display: none;'><div id='sol_message_wrapper' class='bd'><div id='sol_message' class='sol-message'></div></div></div>");
    }
};


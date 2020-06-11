var MessageHandler = {
    addErrorMessage:function (message) {
        var alertTemplate = Handlebars.compile($("#template-alert-message-error").html());
        $("#message-holder").html(alertTemplate({message:message}));
        $("#alert-message-error").alert().delay(5000).fadeOut("fast", function() { $(this).remove(); });
    },

    addMessage:function (message) {
        var alertTemplate = Handlebars.compile($("#template-alert-message").html());
        $("#message-holder").html(alertTemplate({message:message}));
        $("#alert-message").alert().delay(5000).fadeOut("fast", function() { $(this).remove(); });
    }
};

$(document).ready(function () {

    var errorMessage = $(".errorblock");
    if (errorMessage.length > 0) {
    	MessageHandler.addErrorMessage(errorMessage.text());
    }

    var feedbackMessage = $(".messageblock");
    if (feedbackMessage.length > 0) {
    	MessageHandler.addMessage(feedbackMessage.text());
    }
});



/**
 * ITL.plugin.message.js
 * @package js/ITL/plugin
 * @class ITL.plugin
 * @author Md.Rajib-Ul-Islam<mdrajibul@gmail.com>
 * used for common layout event .
 *
 */
ITL.plugin.NotificationMessage = (function() {

    var defaults = {
        template : "<div id=\"notifyMessagePanel\">\
                        <div class=\"image-panel\"></div>\
                        <div class=\"message\"></div>\
                    </div>",
        message:'Loading...',
        messageType:'loading'// loading,success,failure,warning
    };

    var messageContainer;
    var hideShowCounter = 0;

    function initialize(options) {
        if (options) {
            $.extend(defaults, options, true);
        }
        if ($("body").find("#notifyMessagePanel").length > 0) {
            $("body").find("#notifyMessagePanel").remove();
        }
        messageContainer = $(defaults.template);
        setMessageType();
        setMessage();
        showNotification();
    }

    function setMessageType(messageType) {
        if (messageContainer) {
            var imagePanel = messageContainer.find(".image-panel");
            var messagePanel = messageContainer.find(".message-panel");
            if (imagePanel.length > 0) {
                imagePanel.addClass(messageType || defaults.messageType);
            }
            if (messagePanel.length > 0) {
                messagePanel.addClass(messageType || defaults.messageType);
            }
        }
    }

    function setMessage(message) {
        if (messageContainer) {
            messageContainer.find(".message").html((message || defaults.message));
        }
    }

    function showNotification() {
        hideShowCounter = 1;
        $("body").append(messageContainer);
        messageContainer.css({left:($("body").width() / 2 - messageContainer.width() / 2)});
        messageContainer.slideDown(50, function() {
            hideShowCounter = 0;
        });
    }

    function hideNotification() {
        if (hideShowCounter == 0) {
            messageContainer.slideUp(50, function() {
                messageContainer.remove();
            });
        }

    }

    return {
        init:function(options) {
            initialize(options);
        },
        getContainer:function() {
            return messageContainer;
        },
        setMessageType:function(messageType) {
            setMessageType(messageType);
        },
        showNotification:function(message, messageType) {
            if (message) {
                defaults.message = message;
            }
            if (messageType) {
                defaults.messageType = messageType;
            }
            initialize();
        } ,
        hideNotification:function() {
            hideNotification();
        }
    }
}());
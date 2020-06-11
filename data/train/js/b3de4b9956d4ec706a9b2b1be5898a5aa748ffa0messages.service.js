module.factory('messagesService', messagesService);

function messagesService($timeout, $compile, $rootScope){
    
    var wrappElement = document.body.querySelector("#messages");
    if(wrappElement === null){
        wrappElement = angular.element("<div id='messages'></div>");
        angular.element(document.body).prepend(wrappElement);
    }
    
    return {
        showInfo: showInfo,
        showWarning: showWarning,
        showError: showError
    };
    
    function showInfo(msg, showCloseButton, delay){
        showMessage(msg, "info", delay, showCloseButton);
    }
    
    function showWarning(msg, showCloseButton, delay){
        showMessage(msg, "warning", delay, showCloseButton);
    }    
    
    function showError(msg, showCloseButton, delay){
        showMessage(msg, "error", delay, showCloseButton);
    }
    
    function showMessage(msg, messageType, delay, showCloseButton){
        var directiveElement = angular.element("<message-item message='" + msg + "' message-type='" + messageType + "' show-close-btn='" + showCloseButton + "'></message-item>");
        var messageElement = $compile(directiveElement)($rootScope, angular.noop);
        wrappElement.prepend(messageElement);
        $timeout(function(){
            messageElement.remove();
        }, delay || 3000);
    }
}
var notifier = (function () {
    function notify(message, type) {
        noty({
            theme: 'relax',
            type: type,
            text: message,
            animation: {
                open: 'animated fadeIn',
                close: 'animated fadeOut'
            },
            timeout: 3500
        });
    }

    function showSuccessMessage(message) {
        notify(message, 'success')
    }

    function showErrorMessage(message) {
        notify(message, 'error')
    }

    return {
        showSuccessMessage: showSuccessMessage,
        showErrorMessage: showErrorMessage
    }
}());

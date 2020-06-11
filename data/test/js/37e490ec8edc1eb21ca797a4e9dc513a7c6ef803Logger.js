var logger = {
    debug: function(source, message) {
        logger.logMessage('Debug', source, message);
    },
    
    info: function(source, message) {
        logger.logMessage('Info', source, message);
    },
    
    warn: function(source, message) {
        logger.logMessage('Warn', source, message);
    },
    
    error: function(source, message) {
        logger.logMessage('Error', source, message);
    },
    
    fatal: function(source, message) {
        logger.logMessage('Fatal', source, message);
    },
    
    logMessage: function(level, source, message) {
        $.ajax({
            type: "POST",
            url: '/Log/' + level,
            data: {
                url: document.URL,
                source: window.location.pathname + ';  ' + source,
                message: message
            }
        });
    }
}
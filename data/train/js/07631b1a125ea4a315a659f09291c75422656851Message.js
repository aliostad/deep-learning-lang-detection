/**
 * Class Message.
 *
 * @author Maxime Ollagnier
 */
/** Info message type */
Message.INFO = 'INFO';
/** Warning message type */
Message.WARN = 'WARN';
/** Error message type */
Message.ERROR = 'ERROR';

/** Default message string */
Message.DEFAULT_MESSAGE = '';
/** Default message type */
Message.DEFAULT_TYPE = Message.INFO;
/** Default i18n flag */
Message.DEFAULT_I18N = false;

/**
 * Class Message
 * @param {Object} jsonMessage
 */
function Message(jsonMessage)
{
    if (typeof jsonMessage == 'object' && typeof jsonMessage.message == 'string') 
    {
        this.message = jsonMessage.message;
    }
    else 
    {
        this.message = Message.DEFAULT_MESSAGE;
    }
    if (typeof jsonMessage == 'object' && typeof jsonMessage.type == 'string') 
    {
        this.type = jsonMessage.type;
    }
    else 
    {
        this.type = Message.DEFAULT_TYPE;
    }
    if (typeof jsonMessage == 'object' && typeof jsonMessage.i18n == 'boolean') 
    {
        this.i18n = jsonMessage.i18n;
    }
    else 
    {
        this.i18n = Message.DEFAULT_I18N;
    }
}

/**
 * Returns the raw message or the i18n message if necessary
 */
Message.prototype.getMessage = function()
{
    if (this.i18n) 
    {
        return I18nManager.get(this.message);
    }
    else 
    {
        return this.message;
    }
};

/**
 * Logs the message regarding to its type
 */
Message.prototype.log = function()
{
    switch (this.type)
    {
        case Message.INFO:
            Logger.info(this.getMessage());
            break;
        case Message.WARN:
            Logger.warn(this.getMessage());
            break;
        case Message.ERROR:
            Logger.error(this.getMessage());
            break;
    }
};

/**
 * Returns the jQuery message
 */
Message.prototype.getJQ = function()
{
    switch (this.type)
    {
        case Message.INFO:
            return $('<div class="info">' + this.getMessage() + '</div>');
            break;
        case Message.WARN:
            return $('<div class="warn">' + this.getMessage() + '</div>');
            break;
        case Message.ERROR:
            return $('<div class="error">' + this.getMessage() + '</div>');
            break;
    }
};

/**
 * Static method - Returns a message array from a json message array
 */
Message.getMessageArray = function(jsonMessageArray)
{
    var messageArray = new Array();
    for(var i=0; i<jsonMessageArray.length; i++)
    {
        messageArray.push(new Message(jsonMessageArray[i]));
    }
    return messageArray;
};

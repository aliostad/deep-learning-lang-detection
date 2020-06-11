/**
 * Chrome-Extension-Template v1.0
 *
 * @author Dustin Breuer <dustin.breuer@thedust.in>
 * @version 1.0
 * @category chrome-extension
 * @licence MIT http://opensource.org/licenses/MIT
 */

/**
 * A simple message to communicate with scripts
 * @constructor
 */
function Message() {

    /**
     * The Type of the message
     * @type {string}
     * @readonly
     */
    this.type = "undefined";

}

/**
 * The Type of the message
 *
 * @type {string}
 * @readonly
 */
Message.Type = "undefined";

/**
 * A cache-object for message-type to messages
 *
 * @type {Object.<String, Message>}
 * @private
 */
Message.__types = {};

/**
 * Compare the message types(!) of message <i>this</i> and the message <i>oMessage</i>
 * This is not a deep compare
 *
 * @param {Message} oMessage
 *
 * @returns {boolean}
 */
Message.prototype.isEqual = function (oMessage) {
    return this.type === oMessage.type;
};

/**
 * Create a new Message-Type (Factory)
 *
 * @param {String} sMessageType The message type as String
 * @param {Object.<String, *>} [mDefaultValues=null]
 *
 * @returns {Message}
 *
 * @throws {Message.DuplicatedMessageTypeException}
 */
Message.createMessageType = function (sMessageType, mDefaultValues) {

    if (Message.__types[sMessageType]) {
        throw Message.DuplicatedMessageTypeException.createWithMessageType(sMessageType);
    }

    /**
     *
     * @extends {Message}
     * @private
     */
    function ExtendedMessage() {
        Message.call(this);

        this.type = sMessageType;

        if (mDefaultValues) {
            for (var _sKey in mDefaultValues) {
                //noinspection JSUnfilteredForInLoop
                this[_sKey] = mDefaultValues[_sKey];
            }
        }
    }

    ExtendedMessage.Type = sMessageType;

    ExtendedMessage.prototype = Object.create(Message.prototype);
    ExtendedMessage.prototype.constructor = ExtendedMessage;

    Message.__types[sMessageType] = ExtendedMessage;

    return ExtendedMessage;
};

/**
 * Create a Message from type <i>sMessageType</i>
 *
 * @param {String} sMessageType
 *
 * @returns {Message}
 *
 * @throws {Message.UnknownMessageTypeException} Unknown message type
 */
Message.createMessageByType = function (sMessageType) {
    if (!Message.__types[sMessageType]) {
        throw Message.UnknownMessageTypeException.createWithMessageType(sMessageType);
    }

    return new Message.__types[sMessageType];
};

/**
 * Create a Message by a postMessage-Object
 *
 * @param {Object.<String, *>} oPlainObject
 *
 * @returns {Message}
 */
Message.createMessageByPlainObject = function (oPlainObject) {
    if (!oPlainObject.type) {
        throw new ReferenceError("No property 'type' found in Object");
    }

    var _sType = oPlainObject.type;
    delete oPlainObject.type;

    return Message.createMessage(_sType, oPlainObject);
};

/**
 * Create a Message from type <i>sMessageType</i> with the values <i>mValues</i>
 *
 * @param {String} sMessageType The message type as String
 * @param {Object.<String, *>} [mValues=null]
 *
 * @returns {Message}
 *
 * @throws {Message.UnknownMessageTypeException} Unknown message type
 */
Message.createMessage = function (sMessageType, mValues) {
    var _oMessage = Message.createMessageByType(sMessageType);

    if (mValues) {
        for (var _sKey in mValues) {
            //noinspection JSUnfilteredForInLoop
            _oMessage[_sKey] = mValues[_sKey];
        }
    }

    return _oMessage;
};


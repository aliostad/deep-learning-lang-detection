'use strict';

var constants = require('./constants.js');
var bitdog = require('./bitdog.js');

function CommonMessageSchemas() {

    this.__defineGetter__('positionMessageSchema', function () {
        var messageSchema = bitdog.getMessageSchema(constants.MESSAGE_SCHEMA_POSITION);
                                    
        if (messageSchema == null) {
            messageSchema = bitdog.createMessageSchema(constants.MESSAGE_SCHEMA_POSITION)
            .addNumberProperty('x', 0)
            .addNumberProperty('y', 0);
        }

        return messageSchema;

    });
    
    this.__defineGetter__('mapPositionMessageSchema', function () {
        var messageSchema = bitdog.getMessageSchema(constants.MESSAGE_SCHEMA_MAP_POSITION);
        
        if (messageSchema == null) {
            messageSchema = bitdog.createMessageSchema(constants.MESSAGE_SCHEMA_MAP_POSITION)
            .addNumberProperty('latitude', 42.9069)
            .addNumberProperty('longitude',-78.9055923);
        }
        
        return messageSchema;

    });

    this.__defineGetter__('onOffMessageSchema', function () {
        var messageSchema = bitdog.getMessageSchema(constants.MESSAGE_SCHEMA_ON_OFF);
        
        if (messageSchema == null) {
            messageSchema = bitdog.createMessageSchema(constants.MESSAGE_SCHEMA_ON_OFF)
            .addStringProperty('value', 'off', { values: ['on', 'off'] });
        }
        
        return messageSchema;

    });

    this.__defineGetter__('textMessageSchema', function () {
        var messageSchema = bitdog.getMessageSchema(constants.MESSAGE_SCHEMA_TEXT);
        
        if (messageSchema == null) {
            messageSchema = bitdog.createMessageSchema(constants.MESSAGE_SCHEMA_TEXT)
            .addStringProperty('text', '');
        }
        
        return messageSchema;

    });
    
    this.__defineGetter__('valueMessageSchema', function () {
        var messageSchema = bitdog.getMessageSchema(constants.MESSAGE_SCHEMA_VALUE);
        
        if (messageSchema == null) {
            messageSchema = bitdog.createMessageSchema(constants.MESSAGE_SCHEMA_VALUE)
            .addNumberProperty('value', 0);
        }
        
        return messageSchema;

    });

    this.__defineGetter__('rotationMessageSchema', function () {
        var messageSchema = bitdog.getMessageSchema(constants.MESSAGE_SCHEMA_ROTATION);
        
        if (messageSchema == null) {
            messageSchema = bitdog.createMessageSchema(constants.MESSAGE_SCHEMA_ROTATION)
            .addNumberProperty('rotation', 0, {max:360, min:0});
        }
        
        return messageSchema;

    });

    this.__defineGetter__('iftttMessageSchema', function () {
        var messageSchema = bitdog.getMessageSchema(constants.MESSAGE_SCHEMA_IFTTT);
        
        if (messageSchema == null) {
            messageSchema = bitdog.createMessageSchema(constants.MESSAGE_SCHEMA_IFTTT)
            .addStringProperty('value1', '')
            .addStringProperty('value2', '')
            .addStringProperty('value3', '');

        }
        
        return messageSchema;

    });

    
}

module.exports = new CommonMessageSchemas();
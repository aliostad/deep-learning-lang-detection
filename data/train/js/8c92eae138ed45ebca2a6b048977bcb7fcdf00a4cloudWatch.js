/**
 * Created by @raulanatol on 29/05/15.
 */

var slackConnector = require('../slack/connector');

function parseMessageToJSON(message) {
    var jsonMessage;
    try {
        jsonMessage = JSON.parse(message.Message);
    } catch (exception) {
        jsonMessage = {
            "message": message,
            "notificationType": "nonJSONMessage"
        };
    }
    return jsonMessage;
}

function generateDefaultSlackMessage(slackMessage, jsonMessage) {
    slackMessage['text'] = jsonMessage.message;
    slackMessage['attachments'] = [{
        'fallback': jsonMessage.message,
        'text': jsonMessage.message,
        'color': '#000077'
    }];
    return slackMessage;
}

function generateSlackMessageFromNonJson(slackMessage, jsonMessage) {
    slackMessage['text'] = jsonMessage.message;
    slackMessage['attachments'] = {
        'fallback': jsonMessage.message,
        'text': jsonMessage.message,
        'color': '#000077'
    };
    return slackMessage;
}

function generateSlackMessageFromAlarm(slackMessage, jsonMessage) {
    slackMessage['text'] = jsonMessage.message;
    slackMessage['attachments'] = [{
        "fallback": jsonMessage.message,
        "text": jsonMessage.message,
        "color": jsonMessage.NewStateValue == "ALARM" ? "warning" : "good",
        "fields": [{
            "title": "Alarm",
            "value": jsonMessage.AlarmName,
            "short": true
        }, {
            "title": "Status",
            "value": jsonMessage.NewStateValue,
            "short": true
        }, {
            "title": "Reason",
            "value": jsonMessage.NewStateReason,
            "short": false
        }]
    }];
    return slackMessage;
}

exports.cloudWatch = function (req, res) {
    var request = require('request');
    var message = JSON.parse(req.text);

    if (message['Type'] == 'SubscriptionConfirmation') {
        request(message['SubscribeURL'], function (err, result, body) {
            if (err || body.match(/Error/)) {
                res.send('Error: Impossible confirm subscription - URL: ' + message['SubscribeURL'], 500);
            } else {
                console.log("Subscribed to Amazon SNS Topic: " + message['TopicArn']);
                res.send('Ok');
            }
        });
    } else if (message['Type'] == 'Notification') {
        var slackMessage = slackConnector.generateBasicMessage();
        var jsonMessage = parseMessageToJSON(message['Message']);
        //TODO add more notifications type
        if (jsonMessage['AlarmName']) {
            slackMessage = generateSlackMessageFromAlarm(slackMessage, jsonMessage);
        } else if (jsonMessage['notificationType'] == 'nonJSONMessage') {
            slackMessage = generateSlackMessageFromNonJson(slackMessage, jsonMessage);
        } else {
            slackMessage = generateDefaultSlackMessage(slackMessage, jsonMessage);
        }
        slackConnector.publishMessage(request, res, slackMessage);
    } else {
        console.log("Unknown type of message: " + message.Type + ' message: ' + message);
    }
};
var React = require('react');
var MessageTypeConstants = require('../constants/MessageTypeConstants');
var DismissableMessage = require('./DismissableMessage.react');

var MessageView = React.createClass({
	render: function () {
		var messages = this.props.messages;
		var self = this;
		return (
			<div>
			{Object.keys(messages).map(function(message){
				return (
					<DismissableMessage messageText={messages[message].messageText} messageCode={message} messageType={messages[message].messageType} />
				);
			})}
			</div>
		);
	}
});

module.exports = MessageView;
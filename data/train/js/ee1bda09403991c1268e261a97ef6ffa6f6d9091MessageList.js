import React from 'react';
import PropTypes from 'prop-types';

import Message from './Message';
import Alert from './Alert';

class MessageList extends React.Component {

  messageType( message ) {
    if( message.type === "usermessage" ) {
      return (
        <Message key={this.props.messages.indexOf(message)} currentUserId={this.props.currentUserId} messageData={message} />
      );
    } else if( message.type === "alert" ) {
      return (
        <Alert message={message.message} />
      );
    }
  }

  render() {

    var messages = [];
    this.props.messages.map( message => {

      var messageComponent;
      switch( message.type ) {
        case "usermessage":
          messageComponent = <Message key={this.props.messages.indexOf(message)} currentUserId={this.props.currentUserId} messageData={message} />;
          break;
        case "alert":
          messageComponent = <Alert key={this.props.messages.indexOf(message)} message={message.message} />;
          break;
      }

      messages.push( messageComponent );

    });

    return (
      <section className="container-messages">
        {
          messages
        }
      </section>
    );
  }

}

MessageList.propTypes = {
  currentUserId: PropTypes.string.isRequired,
  messages: PropTypes.array.isRequired
}

export default MessageList;

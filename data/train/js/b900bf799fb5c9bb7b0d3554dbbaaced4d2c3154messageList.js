import Message from './message.js';
var MessageList = React.createClass({
  render() {
      return (
          <div className='messageList'>
              {
                  this.props.messages.map((message, i) => {
                      return (
                          <Message
                              key={i}
                              user={"Me"}
                              text={message.text}
                          />
                      );
                  })
              }
          </div>
      );
  }
});
export default MessageList;
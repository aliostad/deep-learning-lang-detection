import React from 'react'
import MessageHeader from "./MessageHeader"
import MessageBody from "./MessageBody"
import MessageFooter from "./MessageFooter"
let ReactPropTypes = React.PropTypes


let Message = React.createClass({

  propTypes: {
    message: ReactPropTypes.object
  },

  render: function() {
    return (
      <div className="letter-container">
        <MessageHeader message={this.props.message} />
        <MessageBody message={this.props.message} />
        <MessageFooter message={this.props.message} />
      </div>
    )
  }
});
module.exports = Message;

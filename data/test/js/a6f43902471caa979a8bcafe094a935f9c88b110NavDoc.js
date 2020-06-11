import React from 'react';
import {Link} from 'react-router';
import Radium from 'radium';
import {Nav, NavItem} from 'react-component-kit';

var styles = {
  button: {
    marginLeft: '10px'
  }
};
var code = `
<Nav activeKey="orange">
  <NavItem key="apple">Apple</NavItem>
  <NavItem key="orange">Orange</NavItem>
  <NavItem key="banana">Banana</NavItem>
</Nav>
`;
export default React.createClass({

  _changeHandler(state){
    this.setState(state);
  },

  render: function () {
    return (
      <div id="components-nav">
        <h2>Nav, NavItem</h2>
        <p>Nav are responsive components that serve as navigation headers for your application. </p>
        <br/>
        <div>
          <span>EXAMPLE: </span>
          <Nav activeKey="orange">
            <NavItem navKey="apple">Apple</NavItem>
            <NavItem navKey="orange">Orange</NavItem>
            <NavItem navKey="banana">Banana</NavItem>
          </Nav>
        </div>
        <br/>
        <div>
          Code: <pre className="prettyprint lang-jsx"> {code.trim()} </pre>
        </div>
      </div>
    );
  }
});

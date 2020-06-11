import React, { Component, PropTypes } from 'react';
import { Navbar, NavBrand, Nav, NavItem} from 'react-bootstrap';

export default class App extends Component {
  render() {
    const { children } = this.props;
    return (
      <div>
        <Navbar>
          <NavBrand>Todo lists</NavBrand>
          <Nav activeKey={1}>
            <NavItem eventKey={1} href="/">Home</NavItem>
          </Nav>
        </Navbar>
        <div className='container'>
          {children}
        </div>
      </div>
    );
  }
}

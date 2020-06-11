'use strict';

import React, { Component } from 'react';
import Navbar from 'react-bootstrap/lib/Navbar';
import Nav from 'react-bootstrap/lib/Nav';
import NavItem from 'react-bootstrap/lib/NavItem';

class Navigation extends Component {
  render() {
    return (
      <Navbar brand='Football Hackday'>
        <Nav>
          <NavItem href='http://footballhackday.github.io/london/'>Website</NavItem>
          <NavItem href='https://github.com/footballhackday/hackday-example'>Source code</NavItem>
          <NavItem href='https://hackday-api.herokuapp.com/'>API</NavItem>
        </Nav>
      </Navbar>
    )
  }
}

export default Navigation;

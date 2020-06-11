import React from 'react';
import { Navbar, NavBrand, Nav, NavItem } from 'react-bootstrap';

class Header extends React.Component {
  render() {
    return (
      <div className="header">
        <Navbar className="navbar-static-top">
          <NavBrand><a href="/"></a>RightClick Admin</NavBrand>
          <Nav>
            <NavItem eventKey={1} href="/statistics">Statistics</NavItem>
            <NavItem eventKey={2} href="/">Lesson History</NavItem>
          </Nav>
        </Navbar>
      </div>
    );
  }
}

export default Header;

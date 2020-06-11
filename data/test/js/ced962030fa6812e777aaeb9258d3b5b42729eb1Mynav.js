import React from 'react';
import { Navbar, NavbarBrand, Nav, NavItem, NavLink } from 'reactstrap';

export default class Mynav extends React.Component {
  render() {
    return (
      <div>
        <Navbar color="faded" light>
          <NavbarBrand href="/">WESTEROS</NavbarBrand>
          <Nav className="float-xs-right" navbar>
            <NavItem>
              <NavLink href="https://www.linkedin.com/in/shubhamjain94">LinkedIn</NavLink>
            </NavItem>
            <NavItem>
              <NavLink href="http://shubh28.github.io/shubham-portfolio/">Github</NavLink>
            </NavItem>
          </Nav>
        </Navbar>
      </div>
    );
  }
}
import React from 'react'
import { Navbar, NavItem, Nav } from 'react-bootstrap';

const Navbarz = () => (
  <Navbar inverse collapseOnSelect>
    <Navbar.Header>
      <Navbar.Brand>
        <a href="#">David's Great Hits</a>
      </Navbar.Brand>
      <Navbar.Toggle />
    </Navbar.Header>
    <Navbar.Collapse>
      <Nav pullRight>
        <NavItem eventKey={1} href="#">Todo</NavItem>
        <NavItem eventKey={2} href="#">Davello</NavItem>
      </Nav>
    </Navbar.Collapse>
  </Navbar>
)

export default Navbarz

// TODO: fix href
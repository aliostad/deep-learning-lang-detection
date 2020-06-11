import React from 'react';
import { Link } from 'react-router';
import { Navbar, NavItem, Nav } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';


const Footbar = props => (
  <Navbar fixedBottom>
    <Nav pullRight>
      <NavItem eventKey={1}>How to Use</NavItem>
      <NavItem eventKey={1}>このサイトについて</NavItem>
      <NavItem eventKey={2}>利用規約</NavItem>
      <NavItem eventKey={2}>お問い合わせ</NavItem>
    </Nav>
  </Navbar>
);

export default Footbar;

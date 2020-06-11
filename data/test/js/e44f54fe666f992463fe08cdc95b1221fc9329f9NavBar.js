import React from 'react';
import {Navbar, Nav, MenuItem, NavDropdown, NavItem} from 'react-bootstrap';
import { Link } from 'react-router';

class NavBar extends React.Component {

  render(){
    const navStyle = {
      marginBottom: '0'
    }
    return(
      <Navbar style={navStyle}>
        <Navbar.Header>
          <Navbar.Brand>
            <Link to="login">PokeDev</Link>
          </Navbar.Brand>
        </Navbar.Header>
        <Nav>
          <NavItem eventKey={1} >GitHub</NavItem>
        </Nav>
    </Navbar>
    )
  }

}

export default NavBar;

import React, {Component} from "react"
import {Navbar, Nav, NavItem} from "react-bootstrap"
import {IndexLinkContainer, LinkContainer} from "react-router-bootstrap"

class SiteNav extends Component {
  render(){
    return(
      <Navbar fluid collapseOnSelect>
        <Navbar.Header>
          <Navbar.Brand><a href="/">BubbleChat</a></Navbar.Brand>
          <Navbar.Toggle />
        </Navbar.Header>
        <Navbar.Collapse>
          <Nav>
            <IndexLinkContainer to="/"  activeClassName="active"><NavItem>Home</NavItem></IndexLinkContainer>
            <NavItem>Account</NavItem>
          </Nav>
          <Nav pullRight>
            <LinkContainer to="/login" activeClassName="active"><NavItem>Login</NavItem></LinkContainer>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    )
  }
}

export default SiteNav

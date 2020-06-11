import React, { Component } from 'react';
import '../styles/NavigationBar.css'
import {
  Navbar,
  NavItem,
  Nav
} from 'react-bootstrap';
import { NavLink } from 'react-router-dom';

// TODO: Add interpolated string in checkout for number of items

class NavigationBar extends Component {
  render() {
    return (
      //className="nav-bar-all nav-perim"
    <Navbar collapseOnSelect>
      <Navbar.Header>
        <Navbar.Brand>
          <p className="brand">Skip the Line</p>
        </Navbar.Brand>
        <Navbar.Toggle />
      </Navbar.Header>
      <Navbar.Collapse>
        <Nav bsStyle="tabs">
          <NavItem className="brand"><NavLink exact to='/'>Home</NavLink></NavItem>
          <NavItem className="brand"><NavLink to='/entrees'>Entrees</NavLink></NavItem>
          <NavItem className="brand"><NavLink to='/sides'>Sides</NavLink></NavItem>
          <NavItem className="brand"><NavLink to='/drinks'>Drinks</NavLink></NavItem>
          <NavItem className="brand"><NavLink to='/desserts'>Desserts</NavLink></NavItem>
          <NavItem className="brand"><NavLink to='/add'>Add</NavLink></NavItem>
        </Nav>
        <Nav bsStyle="tabs"  pullRight>
          <NavItem className="brand"><NavLink to='/summary'><span className="glyphicon glyphicon-shopping-cart"></span>{'  '}Checkout [numItems]</NavLink></NavItem>
        </Nav>
      </Navbar.Collapse>
    </Navbar>
    )
  }
}

export default NavigationBar;

var React = require('react');

var { Navbar, Nav, NavItem } = require('react-bootstrap');

var MyNavbar = module.exports = React.createClass({
  render: function() {
    return (
      <Navbar brand="M &amp; R DMS" inverse className="navbar-static-top">
        <Nav>
          <NavItem href="#">My Cases</NavItem>
          <NavItem href="#">Data Entry</NavItem>
          <NavItem href="#">Assign Cases</NavItem>
          <NavItem href="#">Modify/Delete</NavItem>
          <NavItem href="#">Reports</NavItem>
        </Nav>
      </Navbar>
    );
  }
});

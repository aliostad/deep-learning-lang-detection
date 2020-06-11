var React = require('react');
var { Link } = require('react-router');
var {
  Navbar,
  NavBrand,
  Nav,
  NavItem,
  Image
} = require('react-bootstrap');

class Header extends React.Component {
  render () {
    return (
      <Navbar toggleNavKey={0}>
        <NavBrand>
          <Image src="/images/favicon-96x96.png" responsive />
        </NavBrand>
        <Nav right eventKey={0}>
          <NavItem eventKey={1} href="#/">Home </NavItem>
          <NavItem eventKey={2} href="#/subscribe">Add Subscription </NavItem>
        </Nav>
      </Navbar>
    );
  }
};

module.exports = Header;
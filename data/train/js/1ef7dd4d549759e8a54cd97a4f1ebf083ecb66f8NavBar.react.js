var React = require('react'),
    Bootstrap = require('react-bootstrap'),
    NavBarLink = require('./NavBarLink.react'),
    Navbar = Bootstrap.Navbar,
    Nav = Bootstrap.Nav;

var NavBar = React.createClass({
  render: function() {
    return (
      <Navbar fixedTop brand="Project name">
        <Nav>
          <NavBarLink route="/" text="Home"/>
          <NavBarLink route="/about" text="About"/>
          <NavBarLink route="/contact" text="Contact"/>
          <NavBarLink route="/users" text="Users"/>
          <NavBarLink route="/chat" text="Chat"/>
        </Nav>
      </Navbar>
    );
  }

});

module.exports = NavBar;

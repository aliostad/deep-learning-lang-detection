/**
 * Created by novy on 24.04.15.
 */

var React = require('react');
var RouteHandler = require('react-router').RouteHandler;

var ReactBootstrap = require('react-bootstrap');
var Navbar = ReactBootstrap.Navbar;
var Nav = ReactBootstrap.Nav;

var ReactRouterBootstrap = require('react-router-bootstrap');
var NavItemLink = ReactRouterBootstrap.NavItemLink;

var NavBar = React.createClass({
  render: function () {
    return (
      <Navbar brand="smart-house">

        <Nav>
          <NavItemLink to="lights">
            Lights
          </NavItemLink>
        </Nav>

        <Nav>
          <NavItemLink to="temperatures">
            Temperatures
          </NavItemLink>
        </Nav>

        <Nav>
          <NavItemLink to="configuration">
            Configuration
          </NavItemLink>
        </Nav>


        <RouteHandler />
      </Navbar>
    );
  }
});

module.exports = NavBar;

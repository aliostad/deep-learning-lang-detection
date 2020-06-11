var React = require('react');
var Navbar = require('react-bootstrap').Navbar;
var Nav = require('react-bootstrap').Nav;
var NavItem = require('react-bootstrap').NavItem;

var Header = React.createClass({

    render: function() {
        return (
            <Navbar brand='Blog' toggleNavKey={0}>
                <Nav right eventKey={0}>
                    <NavItem eventKey={1} href="#">首页</NavItem>
                    <NavItem eventKey={2} href="#">关于</NavItem>
                    <NavItem eventKey={3} href="#">注册</NavItem>
                    <NavItem eventKey={4} href="#">登录</NavItem>
                </Nav>
            </Navbar>
        );
    }

});

module.exports = Header;
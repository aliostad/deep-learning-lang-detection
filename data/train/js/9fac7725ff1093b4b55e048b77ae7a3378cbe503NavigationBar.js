'use strict';

GitLog.NavigationBar = React.createClass({
    render: function () {
        var Navbar = ReactBootstrap.Navbar;
        var CollapsibleNav = ReactBootstrap.CollapsibleNav;
        var Nav = ReactBootstrap.Nav;
        var NavItem = ReactBootstrap.NavItem;
        var DropdownButton = ReactBootstrap.DropdownButton;
        var MenuItem = ReactBootstrap.MenuItem;
        var Input = ReactBootstrap.Input;

        var userLink = '#/Users/' + username;

        return (
            <Navbar brand={GitLog.name} toggleNavKey={0} href="#/">
                <CollapsibleNav eventKey={0}> {/* This is the eventKey referenced */}
                    <Nav navbar>
                        <NavItem eventKey={1} href='#/Home'>Home</NavItem>
                        <NavItem eventKey={2} href='#/Dashboard'>Dashboard</NavItem>
                    </Nav>
                    <Nav navbar right>
                        <NavItem eventKey={1} href={userLink}>{username}</NavItem>
                        <NavItem eventKey={2} href='/sign/in'>Sign in</NavItem>
                    </Nav>
                </CollapsibleNav>
            </Navbar>
        )
    }
});

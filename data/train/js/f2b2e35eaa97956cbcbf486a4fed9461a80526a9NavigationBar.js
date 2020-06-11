'use strict';

if (typeof PODB === 'undefined') {var PODB = {};}
if (typeof PODB.component === 'undefined') {PODB.component = {};}

PODB.component.NavigationBar = React.createClass({
    render: function () {
        var Navbar = ReactBootstrap.Navbar;
        var CollapsibleNav = ReactBootstrap.CollapsibleNav;
        var Nav = ReactBootstrap.Nav;
        var NavItem = ReactBootstrap.NavItem;
        var DropdownButton = ReactBootstrap.DropdownButton;
        var MenuItem = ReactBootstrap.MenuItem;
        var Input = ReactBootstrap.Input;

        return (
            <Navbar brand={PODB.name} toggleNavKey={0} href="/#/Home">
                <CollapsibleNav eventKey={0}> {/* This is the eventKey referenced */}
                    <Nav navbar>
                        <NavItem eventKey={1} href='/#/Home'>Home</NavItem>
                        <NavItem eventKey={2} href='/#/Dashboard'>Dashboard</NavItem>
                        <NavItem eventKey={2} href='/#/Users'>Users</NavItem>
                    </Nav>
                    <Nav navbar right>
                        <NavItem eventKey={3} href='/#/Sign/In'>Sign In</NavItem>
                    </Nav>
                </CollapsibleNav>
            </Navbar>
        )
    }
});

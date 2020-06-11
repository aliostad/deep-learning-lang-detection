import React from 'react';
import {Navbar, CollapsibleNav, Nav, NavItem} from 'react-bootstrap';

const NavBar = React.createClass({
    displayName: 'NavBar',
    render: function() {
        return (
            <Navbar brand='Some Site' toggleNavKey={0} className='navbar-somesite' bsStyle='inline'>
                <CollapsibleNav eventKey={0}>
                    <Nav navbar right>
                        <NavItem href='#data'>Data Page</NavItem>
                        <NavItem href='#'>Item 2</NavItem>
                        <NavItem href='#'>Item 3</NavItem>
                    </Nav>
                </CollapsibleNav>
            </Navbar>
        );
    }
});

module.exports = NavBar;

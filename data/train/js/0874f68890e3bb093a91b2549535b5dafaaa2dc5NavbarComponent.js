import React from 'react';
import { Navbar, NavbarBrand, Nav, NavItem, NavLink } from 'reactstrap';

export default class NavbarComponent extends React.Component{
    render(){
        return(
            <div>
                <Navbar color="inverse" inverse toggleable>

                    <NavbarBrand href="/">Tramp-PIZZA</NavbarBrand>
                    <Nav className="ml-auto" navbar>
                        <NavItem>
                            <NavLink href="/reviews/">Reviews</NavLink>
                        </NavItem>
                        <NavItem>
                            <NavLink href="/login">Login</NavLink>
                        </NavItem>
                    </Nav>
                </Navbar>
            </div>
        );
    }
}


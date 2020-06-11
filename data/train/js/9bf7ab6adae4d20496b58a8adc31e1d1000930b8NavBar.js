'use strict';

import React from 'react';
import Navbar from 'react-bootstrap/lib/Navbar';
import NavItem from 'react-bootstrap/lib/NavItem';
import Nav from 'react-bootstrap/lib/Nav';
import CollapsibleNav from 'react-bootstrap/lib/CollapsibleNav';

import ShoppingCart from './ShoppingCart.js';

var NavBar = React.createClass({
	render: function () {
		return (
			<Navbar brand='TREIF AND MORE TREIF!' toggleNavKey={0}>
				<CollapsibleNav eventKey={0}> 
					<Nav navbar>
			      <NavItem>Link?</NavItem>
			      <NavItem>Link?</NavItem>
		      </Nav> 
		      <Nav navbar right>
		      	<ShoppingCart name={this.props.name} cart={this.props.cart}/>
					</Nav>		
		    </CollapsibleNav>
		  </Navbar>
		);
	}
});

module.exports = NavBar;

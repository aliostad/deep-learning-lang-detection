import React from 'react';
import { Navbar, NavItem, Nav, MenuItem, NavDropdown } from 'react-bootstrap';

class Dashboard extends React.Component {
	render() {
		return (
			<div>
				<Navbar inverse staticTop>
					<Navbar.Header>
						<Navbar.Brand>
							<a href="#">Gear Test Automation</a>
						</Navbar.Brand>
						<Navbar.Toggle />
					</Navbar.Header>
					<Navbar.Collapse>
						<Nav>
							<NavItem eventKey={1} href='/scripts'>Scripts</NavItem>
							<NavItem eventKey={2} href='/parameters'>Parameters</NavItem>
							<NavItem eventKey={3} href='/reports'>Reports</NavItem>
							<NavItem eventKey={4} href='/guide'>Reports</NavItem>
						</Nav>
						<Nav pullRight>
							<NavItem eventKey={0} href='/login'>Login</NavItem>
						</Nav>
					</Navbar.Collapse>
				</Navbar>
				{this.props.children}
			</div>
		);
	}
}

export default Dashboard;
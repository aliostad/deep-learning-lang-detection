import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';

function Nav({children}) {
  console.log(children);
  let items = React.Children.toArray(children);
  let navItems = [];

  for (let i = 0; i < items.length; i++) {
    if (items[i].type.name !== 'NavItem') {
      throw 'All children must be of type NavItem, not ' + items[i].type.name;
    }
    navItems[i] = (
      <NavItem url={items[i].props.url}>
        {items[i].props.children}
      </NavItem>
    );
  }

  return (
    <nav className="navbar navbar-toggleable-md navbar-inverse bg-inverse">
      <a className="navbar-brand" href="#">
        Navbar
      </a>
      <div className="collapse navbar-collapse" id="navbarNav">
        <ul className="navbar-nav">
          {navItems}
        </ul>
      </div>
    </nav>
  );
}

function NavItem(props) {
  return (
    <li className="nav-item">
      <a className="nav-link" href={props.url}>
        {props.children}
      </a>
    </li>
  );
}

ReactDOM.render(
  <Nav>
    <NavItem url="/">Home</NavItem>
    <NavItem url="/About">About</NavItem>
    <NavItem url="/Contact">Contact</NavItem>
    <NavItem url="/Careers">Careers</NavItem>
  </Nav>,
  document.getElementById('root'),
);

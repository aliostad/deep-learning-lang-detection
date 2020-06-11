import React from 'react';

import { NavLink } from 'react-router-dom';

function BaseLayout ({children}) {
  return (
    <div className="col-md-6 offset-md-3">
      <nav className="navbar navbar-toggleable-md  navbar-light" style={{backgroundColor:"lightBlue"}}>
        <div className="navbar-nav mr-auto">
          <NavLink to="/" className="nav-item nav-link" style={{color:"blue"}}>BankShot</NavLink>
          <NavLink to="/" className="nav-item nav-link">Home</NavLink>
          <NavLink to="/users" className="nav-item nav-link">Users</NavLink>
        </div>
      </nav>
      {children}
    </div>
  );
}

export default BaseLayout;
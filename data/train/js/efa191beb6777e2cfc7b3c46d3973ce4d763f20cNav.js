import React from 'react';
import { NavLink } from 'react-router-dom';

function Nav () {

  return (
    <div className="Nav">
      <ul className="Nav-ul">
        <li >
          <NavLink exact className="nav-link" activeClassName="active" to="/">
            Home
          </NavLink>
        </li>
        <li>
          <NavLink exact className="nav-link"  activeClassName="active" to="/champions">
            All Champions
          </NavLink>
        </li>
        <li>
          <NavLink exact className="nav-link" activeClassName="active" to="/champions/favorites">
            Favorite Champions
          </NavLink>
        </li>
      </ul>
    </div>
  )
}
export default Nav;

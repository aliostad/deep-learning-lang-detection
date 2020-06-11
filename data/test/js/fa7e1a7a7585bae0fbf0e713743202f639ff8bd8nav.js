import React from 'react';
import { NavLink } from 'react-router-dom';

const Nav = () => {
  return (
    <div>
      <ul className="nav-wrapper">
        <li>
          <NavLink exact activeClassName="active" activeStyle={{textDecoration: 'underline'}} to="/">
            Warriors
          </NavLink>
        </li>
        <li>
          <NavLink activeClassName="active" activeStyle={{textDecoration: 'underline'}} to="/cavaliers">
            Cavaliers
          </NavLink>
        </li>
      </ul>
    </div>
  )
}


export default Nav;

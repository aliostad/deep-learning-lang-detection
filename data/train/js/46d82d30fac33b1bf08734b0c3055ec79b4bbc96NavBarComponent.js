import React, { Component } from 'react';
import { NavLink } from 'fluxible-router';
if (process.env.BROWSER) {
  require('../style/NavBar.scss');
}

class NavBar extends Component {

  render() {
    return (
      <div className="NavBar">
        <div className="NavBar-links Grid Grid--center">
          <NavLink href="/" className="NavBar-link">
            <img src="https://hubrick.com/images/logo.png" alt=""/>
          </NavLink>
          <NavLink
            className="NavBar-link"
            routeName="flows"
            href="/flows/">
            Flows
          </NavLink>
        </div>
      </div>
    );
  }

}

export default NavBar;

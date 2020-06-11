import React from 'react';
import { Link } from 'react-router';
import NavLink from './NavLink';

export default React.createClass({
  render() {
    return (
      <div>
        <ul role="nav" className="navbar">
          <li><NavLink to="/" activeClassName="active" onlyActiveOnIndex={true}>Home</NavLink></li>
          <li><NavLink to="/location">Location</NavLink></li>
          <li><NavLink to="/moon">Today</NavLink></li>
          <li><NavLink to="/gallery">Gallery</NavLink></li>
          <li><NavLink to="/apod">APOD</NavLink></li>
          <li><NavLink to="/reviews">Reviews</NavLink></li>
        </ul>

        {this.props.children}
      </div>
    )
  }
})

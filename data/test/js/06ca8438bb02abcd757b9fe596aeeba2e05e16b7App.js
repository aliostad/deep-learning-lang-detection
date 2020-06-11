import React, { Component } from 'react';
import NavLink from './NavLink';

class App extends Component {
  render() {
    return (
      <div className="container">
        <header>
          <span className="icn-logo"><i className="material-icons">code</i></span>
          <ul className="main-nav">
            <li><NavLink to="/">Home</NavLink></li>
            <li><NavLink to="/about">About</NavLink></li>
            <li><NavLink to="/teachers">Teachers</NavLink></li>
            <li><NavLink to="/courses">Courses</NavLink></li>
          </ul>
        </header>
        { this.props.children }
      </div>
    );
  }
}

export default App;

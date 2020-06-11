import React from 'react';
import NavLink from './NavLink';

export default class App extends React.Component {
  render() {
    let year = new Date().getFullYear();

    return <div id="app">
      <header>
        <h1>Interdoodle</h1>
        <nav id="primary">
          <NavLink to="/" onlyActiveOnIndex>Home</NavLink>
          <NavLink to="/projects">Projects</NavLink>
          <NavLink to="/work">Work</NavLink>
          <NavLink to="/about">About</NavLink>
        </nav>
        <nav id="user">
          <NavLink to="/login" id="login">Login</NavLink>
        </nav>
      </header>
      <main>
        {this.props.children}
      </main>
      <footer>
        <p className="copyright">Copyright {year} Interdoodle Ltd.  All Rights Reseaved.</p>
        <p>Interdoodle Ltd. is registered in Ireland (Company No: ).</p>
      </footer>
    </div>;
  }
}

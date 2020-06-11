import React from 'react';
import NavBrand from './NavBrand.js';
import NavLinks from './NavLinks.js';

class NavBar extends React.Component {
  constructor() {
    super();
  }

  render(){
    return (
      <header>
        <div className="_navbar">
          <NavBrand />
        </div>
        <div className="_navbar _navbar_grow">
          <NavLinks pages={this.props.pages} route={this.props.route} />
        </div>
        <div className="_navbar">

        </div>
      </header>
    );
  }
}

export default NavBar;

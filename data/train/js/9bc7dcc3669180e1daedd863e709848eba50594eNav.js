'use strict';

/// HEADER::NAV
var React      = require('react'),
    NavItem    = require('./NavItem.js'),
    pkg        = require('../../../package.json');



var Nav = React.createClass({

  render: function() {
    return (
      <ul className="list list-l-horizontal list-t-nav">
        {
          pkg.components.navItems.map(function(navItem, index){
            var active = this.props.activeBoard === navItem.toLowerCase().replace(' ', '_') ? true : false;
            return <NavItem key={index} title={navItem} active={active} activeBoard={this.props.activeBoard} />
          }.bind(this))
        }
      </ul>
    )
  }
});

module.exports = Nav;

var React = require('react');
var Reflux = require('reflux');
var NavItem = require('./NavItem.react');
var NavStore = require('./../stores/NavStore');
var NavActions = require('./../actions/NavActions');

var Nav = React.createClass({
    mixins: [Reflux.connect(NavStore, 'nav')],
    // NOTE: as we starting with static data, we don't need to get anything
    //componentDidMount: function() {
    //    NavActions.get();
    //},
    render: function() {
        var navItems = [];

        this.state.nav.forEach((navItem, index) => {
            navItems.push(
                <NavItem key={index} {...navItem}>
                    {navItem.title}
                </NavItem>
            )
        });

        return (
            <nav className='nav'>
                {navItems}
            </nav>
        );
    }
});

module.exports = Nav;
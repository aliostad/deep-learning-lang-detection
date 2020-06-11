var React = require('react');
var NavLink = require('react-router-dom').NavLink;

function Nav(props) {
    return (
        <ul className='nav'>
            <li>
                <NavLink activeClassName='active' exact to='/'>
                    Home
                </NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/battle'>
                    Battle
                </NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/popular'>
                    Popular
                </NavLink>
            </li>
        </ul>
    );
}

module.exports = Nav;
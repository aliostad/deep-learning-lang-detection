import React from 'react';

const NavBar = (props) => {
    return (
        <nav className="nav has-shadow">
            <div className="container">
                <div className="nav-left">
                    <a href="https://validar.com">
                        <img className="logo" src={require('../static/logo.png')} />
                    </a>
                </div>
                <div className="nav-right">
                    <h2 className="nav-item title is-3">etouches registrant data</h2>
                </div>
            </div>
        </nav>
    );
};

export default NavBar;
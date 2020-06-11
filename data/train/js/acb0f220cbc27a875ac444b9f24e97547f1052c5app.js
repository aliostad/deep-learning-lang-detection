import React from 'react';
import Nav from './nav';
import NavLeft from './nav-left';

require('../../css/app.css');
require('../../css/nav-left.css');
require('../../css/nav-right.css');

export default class App extends React.Component {
    render() {
        return <div className="app-body">
            <Nav/>
            <div  className="navLeft">
                <NavLeft/>
            </div>
            <div className="nav-right">
                {this.props.children}
            </div>
        </div>;
    }
}

import React from 'react';
import {hashHistory} from 'react-router';
import NavLogo from './NavLogo';
import NavMenu from './NavMenu';
import NavSearch from './NavSearch';
import '../../../Style/Component/Nav/NavComponent.css';
class NavComponent extends React.Component {
    handleEnter = event => {
        hashHistory.push('/search/' + event.target.value);
    };

    render() {
        return (
            <div className="NavComponent">
                <div className="NavContainer container clear">
                    <NavLogo/>
                    <NavSearch value={this.props.value || ''} enter={this.handleEnter} />
                    <NavMenu/>
                </div>
            </div>
        );
    }
}
export default NavComponent;
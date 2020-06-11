import React,{Component,PropTypes} from 'react';
import NavLink from './NavLink'

class Header extends Component{
    render(){
        return(
            <header className="header">
                <span>HEART&ME</span>
                <nav className="menu">
                    <NavLink to="">Home</NavLink>
                    <NavLink to="">Story</NavLink>
                    <NavLink to="">Photo</NavLink>
                    <NavLink to="">About</NavLink>
                    <span className="bar"></span>
                    <button>X</button>
                </nav>
            </header>
        )
    }
}

export default Header;
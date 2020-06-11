import  React  from 'react';
import  NavLink  from './NavLink';

const HeaderMenu = () => {
    return (
        <nav className="navbar  navbar-default" >
            <div className="container-fluid" >
                <a className="navbar-brand" href="#">Laravel  react</a>
            </div>

            <ul className="nav  navbar-nav">
               <NavLink to="/">Home</NavLink>
               <NavLink to="/create">Create</NavLink>

         
            </ul>

        </nav>

    )
}

export default HeaderMenu;
import React, { Component } from 'react'
import { Link } from 'react-router'
import classNames from 'classnames'

if (process.env.WEBPACK_BUILD) {
    require('../styles/Nav.scss')
}

const navItems = [
    {
        id: 'writing',
        label: 'Writing',
        link: '/writing'
    },
    {
        id: 'about',
        label: 'About',
        link: '/about'
    }
]

const Nav = ({ currentPage }) => {
    return (
        <div className='Nav nav-bar'>
            <nav>
                <ul className='nav_list'>
                    { navItems.map((item, i) => {
                        const navItemClasses = classNames({
                            'nav_list__item': true,
                            'nav_list__item--active': currentPage === item.id
                        })
                        return (<li className={ navItemClasses } key={ i }><Link to={ item.link }>{ item.label }</Link></li>)
                    })}
                </ul>
            </nav>
        </div>
    )
}

Nav.propTypes = {}

export default Nav

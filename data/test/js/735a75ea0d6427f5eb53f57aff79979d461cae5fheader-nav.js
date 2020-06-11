'use strict'

import React from 'react'
import { Motion, spring } from 'react-motion'
import PropTypes from 'prop-types'

import HeaderNavButton from './header-nav-button'
import { navLinks } from '../../constants'

const HeaderNav = (props) => {
  return (
    <Motion className='header-nav-container' defaultStyle={{x: -10, o: 0}} style={{
      x: spring(props.navActive ? 1.5 : -75, {stiffness: 60, damping: 15}),
      o: spring(props.navActive ? 1 : 0, {stiffness: 60, damping: 20})
    }}>
    {interpolation => {
      return (
        <nav className='header-nav' style={{left: `${interpolation.x}rem`, opacity: interpolation.o}}>
          <ul>
            {navLinks.map((item) => <HeaderNavButton key={`nav-button-${item.name}`} item={item} />)}
          </ul>
        </nav>
      )
    }
  }
  </Motion>)
}

HeaderNav.propTypes = {
  navActive: PropTypes.bool
}

export default HeaderNav

import React from 'react';
import PropTypes from 'prop-types';
import { navList } from '../../../constants/routes/view';
// import Drawer from 'material-ui/Drawer';
import Paper from 'material-ui/Paper';
import NavItem from '../NavItem';
import './Nav.css';

const buildNavItem = (route, key) => (
  <NavItem
    key={ key }
    path={ route.path }
    text={ route.name }
  />
);

const Nav = (props) => {
  const { navOpen, toggleNav } = props;
  const classNames = ['nav'];
  navOpen ? classNames.push('open') : classNames.push('closed');

  return (
    <Paper
      className={ classNames.join(' ') }
      onClick={ toggleNav }
    >
      { navList.map(buildNavItem) }
    </Paper>
  );
};

Nav.propTypes = {
  navOpen: PropTypes.bool,
  toggleNav: PropTypes.func.isRequired,
};

export default Nav;

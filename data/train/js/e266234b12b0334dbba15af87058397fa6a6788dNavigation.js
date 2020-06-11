import React, { Component } from 'react';
import { map, where, partial } from 'lodash';
import NavigationActions from '../actions/NavigationActions';
import NavigationStore from '../stores/NavigationStore';

function getState() {
  return {
    selectedNav: NavigationStore.getSelectedNav(),
    navOptions: NavigationStore.getNavOptions(),
    navSections: NavigationStore.getNavSections()
    
    // example:
    // selectedNav: 'PLAYING',
    // navOptions: [
    //   {
    //     id: 'PLAYING',
    //     display: 'Playing',
    //     href: '#playing',
    //     icon_url: '',
    //     nav_section: 'MAIN'
    //   }
    // ],
    // navSections: [
    //   {
    //     id: 'MAIN',
    //     display: 'Main'
    //   }
    // ]
  };
}

export default class Navigation extends Component {
  state = getState()

  componentDidMount() {
    this._onChange = this._onChange.bind(this);
    NavigationStore.addChangeListener(this._onChange);
  }

  componentWillUnmount() {
    NavigationStore.removeChangeListener(this._onChange);
  }

  render() {
    const selectedNav = this.state.selectedNav;
    return <nav className='Navigation'>
      <ul className='Navigation__sections'>{ map(this.state.navSections, navSection =>
        <li className='Navigation__section' key={navSection.id}>
          <h3 className='Navigation__section-header'>{navSection.display}</h3>
          <ul className='Navigation__options'>{ map(this.getNavOptionsForSection(navSection), navOption =>
            <li
              className={(selectedNav === navOption.id ? 'Navigation__option--selected' : 'Navigation__option')}
              key={navOption.id}>
              <a className='Navigation__option-link' href={navOption.href} onClick={partial(this._onNavClick, navOption.id)}>
                {navOption.display}
              </a>
            </li>
          )}</ul>
        </li>
      )}</ul>
    </nav>;
  }

  getNavOptionsForSection(navSection) {
    return where(this.state.navOptions, { nav_section: navSection.id });
  }

  _onNavClick(navId) {
    NavigationActions.changeNav(navId);
  }

  _onChange() {
    this.setState(getState());
  }
};

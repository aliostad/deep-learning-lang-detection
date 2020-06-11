import React, { Component } from 'react'
import NavLink from '../../components/NavLink'

class App extends Component {
  render() {
    return (
      <div className='container'>
        <ul className='nav nav-pills'>
          <li><NavLink onlyActiveOnIndex={true} to='/'>Главная</NavLink></li>
          <li><NavLink to='/admin'>Админка</NavLink></li>
          <li><NavLink to='/list'>Список жанров</NavLink></li>
          <li><NavLink to='/login'>Войти</NavLink></li>
        </ul>
        {this.props.children}
      </div>
    )
  }
}

export default App

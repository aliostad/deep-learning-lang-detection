import React, { Component } from 'react'
import { Nav, NavItem } from 'react-bootstrap'

export default class extends Component {
  static styleguide = {
    index: '15.1',
    category: 'Molecules - Navigation',
    title: 'Navs',
    description: 'Navs come in two styles, pills and tabs. Disable a tab by adding `disabled`.',
    code: `
<Nav bsStyle="pills" activeKey={1} onSelect={handleSelect}>
  <NavItem eventKey={1} href="/home">NavItem 1 content</NavItem>
  <NavItem eventKey={2} title="Item">NavItem 2 content</NavItem>
  <NavItem eventKey={3} disabled>NavItem 3 content</NavItem>
</Nav>
    `
  }

  handleSelect(selectedKey) {
    alert('selected ' + selectedKey);
  }

  render () {
    return (
        <Nav bsStyle="pills" activeKey={1} onSelect={this.handleSelect}>
          <NavItem eventKey={1} href="#!/Navigation">NavItem 1 content</NavItem>
          <NavItem eventKey={2} title="Item">NavItem 2 content</NavItem>
          <NavItem eventKey={3} disabled>NavItem 3 content</NavItem>
        </Nav>
    )
  }
}

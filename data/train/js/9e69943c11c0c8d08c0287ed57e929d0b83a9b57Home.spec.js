import 'jsdom-global/register';
import React from 'react';
import { expect } from 'chai';
import { mount, shallow } from 'enzyme';
import { spy } from 'sinon';

import { Home } from './Home';

describe('<HomeForm />', () => {
  let dispatch = function(){
      console.log('dispatch');
  }


  it('calls componentWillMount', () => {
    const componentDidMountSpy = spy(Home.prototype, 'componentWillMount');
    const wrapper = mount(
        <Home dispatch={dispatch}/>
    );
    expect(Home.prototype.componentWillMount.calledOnce).to.equal(true);
    componentDidMountSpy.restore();
  });

  it('calls dispatch', () => {
    dispatch = spy();
    const wrapper = mount(
        <Home dispatch={dispatch}/>
    );
    expect(dispatch.calledOnce).to.equal(true);
  });
});

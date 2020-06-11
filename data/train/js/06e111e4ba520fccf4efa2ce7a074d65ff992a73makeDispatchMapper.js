/* global describe, it */
import expect from 'expect.js';

import { makeDispatchMapper } from '../index';

describe('makeDispatchMapper', function () {
  it('is a function', function () {
    expect(makeDispatchMapper).to.be.a('function');
  });

  it('generates props with functions', function () {
    const dispatch = function (action) {
      return action.type;
    };

    const ADD_TODO = 'ADD_TODO';
    const addTodo = function (text) {
      return {
        type: ADD_TODO,
        text
      };
    };

    const mapDispatchToProps = makeDispatchMapper({
      addTodo
    });

    expect(mapDispatchToProps).to.be.a('function');

    const props = mapDispatchToProps(dispatch);
    expect(props).to.have.key('addTodo');
    expect(props.addTodo).to.be.a('function');
    expect(props.addTodo()).to.be(ADD_TODO);
  });
});

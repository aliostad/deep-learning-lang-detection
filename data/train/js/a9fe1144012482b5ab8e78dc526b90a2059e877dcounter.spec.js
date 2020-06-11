/**
 * Copyright 2016 <%= name %>
 * MIT Licensed
 *
 * @module reducers/Counter.spec.js
 */

import test from 'ava';
import counter from '../../lib/js/reducers/counter';
import { INCREMENT, DECREMENT, RESET } from '../../lib/js/constants/counter';

function dispatch(action, state) {
  return counter(state, { type: action });
}

test('null', t => {
  t.plan(2);
  t.is(dispatch(), 0);
  t.is(dispatch(null, 10), 10);
});

test('INCREMENT', t => {
  t.plan(2);
  t.is(dispatch(INCREMENT), 1);
  t.is(dispatch(INCREMENT, 10), 11);
});

test('DECREMENT', t => {
  t.plan(2);
  t.is(dispatch(DECREMENT), -1);
  t.is(dispatch(DECREMENT, 10), 9);
});

test('RESET', t => {
  t.plan(2);
  t.is(dispatch(RESET), 0);
  t.is(dispatch(RESET, 10), 0);
});

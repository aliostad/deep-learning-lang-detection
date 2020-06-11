import { createStore } from 'redux';
import { loadState, saveState } from './localStorage';
import { formatTime } from './helpers';

import * as testTypes from './constants/testTypes';

import rememberApp from './store/reducers.js';

const addLoggingToDispatch = (store) => {
  const rawDispatch = store.dispatch;
  if (!console.group) {
    return rawDispatch;
  }

  return (action) => {
    console.groupCollapsed(`${action.type} (${formatTime(new Date())})`);
    console.log('%c prev state', 'color: gray', store.getState());
    console.log('%c action', 'color: blue', action);
    const returnValue = rawDispatch(action);
    console.log('%c next state', 'color: green', store.getState());
    console.groupEnd(action.type);
    return returnValue;
  }
}

const addCallbackToDispatch = (store) => {
  const rawDispatch = store.dispatch;
  // action(rawDispatch, store.getState)
  return (action) => {
    return (typeof(action) === 'function') ?
      action(rawDispatch, store.getState) :
      rawDispatch(action);
  }
}

const addLocalStorageToDispatch = (store) => {
  const rawDispatch = store.dispatch;
  return (action) => {
    if (typeof(action.localDataState) === 'object')
      saveState(action.localDataState);

    return rawDispatch(action);
  }
}

export const configureStore = () => {
  let initialState = {};
  let persistedState = loadState();

  if (persistedState) {
    initialState = {
      tests: {[testTypes.REMEMBER]: {
        completed: persistedState.completed,
        cards: [],
        cardsToTrain: [],
        quantity: 5
      }}
    }
  }

  const store = createStore(rememberApp, initialState);
  store.dispatch = addLoggingToDispatch(store);
  store.dispatch = addLocalStorageToDispatch(store);
  store.dispatch = addCallbackToDispatch(store);

  return store;
}

import mapObj from 'map-obj';

export const bindActionCreator = (creator, dispatch) =>
  (...args) => dispatch(creator(...args));

export const bindActionCreators = (creators, dispatch) =>
  mapObj(creators, (key, creator) => [key, bindActionCreator(creator, dispatch)]);

// middleware: store => dispatch => action

export const applyMiddleware = (store, middlewares) => {
  middlewares = middlewares.slice();
  middlewares.reverse();

  let dispatch = store.dispatch;
  middlewares.forEach((m) => {
    dispatch = m(store)(dispatch);
  });

  return { ...store, ...{ dispatch } };
}

function applyMiddleware(...middlewares) {
  return function enhancer(createStore) {
    return function (reducer) {
      var store = createStore(reducer)
      var dispatch = store.dispatch
      var chain = []

      var middlewareAPI = {
        getState: store.getState,
        dispatch: function (action) {
          return dispatch(action)
        }
      }

      // 单个 middleware
      // dispatch = middleware(middlewareAPI)(store.dispatch)

      // middleware 链
      chain = middlewares.map(middleware => middleware(middlewareAPI))
      // dispatch = chain[0](store.dispatch);
      // dispatch = chain[1](dispatch);
      dispatch = compose(...chain)(store.dispatch)

      return Object.assign({},store, {dispatch})
    }
  }
}

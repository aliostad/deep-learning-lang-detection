// create a store enhancer that apply the middleware to the 'dispatch' of the Redux Stroe
// each middleware will be given the 'dispatch' and 'getState' functions
// usage: applyMiddleware(thunk)(createStore)

export default function applyMiddleware(...middlewares) {
  return (createStore) => (reducer, initialState, enhancer) => {
    var store = createStore(reducer, initialState, enhancer)
    var dispatch = store.dispatch
    var chain = []

    var middlewareAPI = {
      getState: store.getState,
      dispatch: (action) => dispatch(action)
    }
    chain = middlewares.map(
      middleware => middleware(middlewareAPI)
    )
    dispatch = compose(...chain)(store.dispatch)

    return {
      ...store,
      dispatch
    }
  }
}

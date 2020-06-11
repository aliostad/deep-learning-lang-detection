public static partial class Redux {

	public static ApplyMiddleware applyMiddleware = (middlewares) => {
		
		return (createStore) => (finalReducer, initialState, enhancer) => {

			var store = createStore (finalReducer, initialState, enhancer);
			var _dispatch = store.dispatch;
			var chain = new ComposedDispatch[middlewares.Length];

			var middlewareAPI = new MiddlewareAPI () {
				getStateTree = store.getStateTree,
				getState = store.getState,
				dispatch = (action) => {
					return _dispatch (action);
				}
			};

			for (int i = 0, len = middlewares.Length; i < len; ++i) {
				chain[i] = middlewares[i](middlewareAPI);
			}
			_dispatch = composeDispatch (chain) (store.dispatch);

			store.dispatch = _dispatch;
			return store;
		};
	};
}
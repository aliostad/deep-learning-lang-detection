
import * as actions from './actions.js';
import { createStore } from 'redux';
import { reducers } from './reducers';
import { get } from '../services/http.js';

export let store = createStore(reducers);
export let dispatch = store.dispatch;
export let unsubscribe = store.subscribe(() => {
    // in development mode uncomment
    //console.log(store.getState());
});

dispatch(actions.applyDefaults());
dispatch(actions.markers([]));
dispatch(actions.deals([]));
dispatch(actions.news([]));
dispatch(actions.tips([]));

get(`/markers/get`, json => dispatch(actions.markers(json.markers)));
get(`/deals/get`, json => dispatch(actions.deals(json.deals)));
get(`/news/get`, json => dispatch(actions.news(json.news)));
get(`/tips/get`, json => dispatch(actions.tips(json.tips)));
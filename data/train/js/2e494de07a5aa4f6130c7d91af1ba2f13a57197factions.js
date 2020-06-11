import * as constants from '../constants/actionTypes';
import fetchWrapper, {errorActionHandler}  from '../utils/actionsHelper';
import { showLoading, hideLoading } from 'react-redux-loading-bar';
import {API} from '../config'


function itemsList(data) {
    return {
        type: constants.LIST_ITEMS,
        payload: data
    };
}


export function itemsListAsync() {
    let options = {
        method: 'get',
        headers: {
            'Content-Type': 'application/json',
        }
    };
    return (dispatch) => {
        dispatch(showLoading());
        return fetchWrapper(API + '/items/', options)
            .then(success => {
                dispatch(itemsList(success));
                dispatch(hideLoading());
            })
            .catch(errorActionHandler(dispatch))
    };
}

export function createItemAsync(data) {
    let options = {
        method: 'post',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify( data )
    };
    return (dispatch) => {
        dispatch(showLoading());
        return fetchWrapper(API + '/items/', options)
            .then(success => {
                dispatch(hideLoading());
                return success;
            })
            .catch(errorActionHandler(dispatch))
    };
}

export function getItemAsync(id) {
    let options = {
        method: 'get',
        headers: {
            'Content-Type': 'application/json',
        },
    };
    return (dispatch) => {
        dispatch(showLoading());
        return fetchWrapper(API + '/items/' + id + '/', options)
            .then(success => {
                dispatch(hideLoading());
                return success;
            })
            .catch(errorActionHandler(dispatch))
    };
}

export function updateItemAsync(data) {
    let options = {
        method: 'put',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify( data )
    };
    return (dispatch) => {
        dispatch(showLoading());
        return fetchWrapper(API + '/items/' + data.id + '/', options)
            .then(success => {
                dispatch(hideLoading());
                return success;
            })
            .catch(errorActionHandler(dispatch))
    };
}

export function deleteItemAsync(id) {
    let options = {
        method: 'delete',
        headers: {
            'Content-Type': 'application/json'
        },
    };
    return (dispatch) => {
        dispatch(showLoading());
        return fetchWrapper(API + '/items/' + id + '/', options)
            .then(success => {
                dispatch(hideLoading());
                return success;
            })
            .catch(errorActionHandler(dispatch))
    };
}
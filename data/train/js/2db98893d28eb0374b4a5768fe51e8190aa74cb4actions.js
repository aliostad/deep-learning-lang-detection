import { pushState } from 'redux-router'

export function loadingUserData() {
    return {
        type: 'LOADING_USER_DATA',
    }
}

export function loggedOut() {
    return {
        type: 'LOGGED_OUT',
    }
}

export function userDataLoaded(user) {
    return {
        type: 'USER_DATA_LOADED',
        payload: user
    }
}

export function loggedIn(user) {
    return {
        type: 'LOGGED_IN',
        payload: user
    }
}

export function userDataLoadingFailed() {
    return {
        type: 'USER_DATA_LOADING_FAILED'
    }
}

export function loadUserData() {

    return function(dispatch) {
        dispatch(loadingUserData())

        dispatch({
            type: 'API_GET',
            uri: '/api/users/me',
            onSuccess: (dispatch, result) => {
                dispatch(userDataLoaded(result))
            },
            onError: (dispatch, error) => {
                dispatch(userDataLoadingFailed())
            }
        })
    }
}

export function logout() {

    return function(dispatch) {
        dispatch({
            type: 'API_GET',
            uri: '/api/users/logout',
            onSuccess: (dispatch, result) => {
                dispatch(loggedOut())
                dispatch(pushState(null, '/'))
            },
            onError: (dispatch, error) => {
                // TODO handle this better
                dispatch(loggedOut())
                dispatch(pushState(null, '/'))
            }
        })
    }
}

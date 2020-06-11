import { remote } from 'electron';
import { persistState, clearPersistedState } from './persist';
import config from '../../default.config';
import types from './actionTypes';

export function lockStore () {
    return (dispatch) => {
        dispatch({ type: types.LOCK });
        dispatch(clearPersistedState());
    };
}

export function unlockStore (items, password) {
    return (dispatch) => {
        dispatch({ type: types.UNLOCK, items, password });
        dispatch(persistState());
    };
}

export function createStore (password) {
    return (dispatch) => {
        dispatch({ type: types.CREATE_STORE, password });
        dispatch(clearPersistedState());
    };
}

export function updateStoreFile () {
    return dispatch => {
        dispatch(lockStore());
        remote.dialog.showOpenDialog({ properties: ['openFile'] }, ([storeFile]) => {
            dispatch({ type: types.UPDATE_STORE_FILE, storeFile });
            dispatch(persistState());
        });
    };
}

export function useDefaultStoreFile () {
    return dispatch => {
        dispatch(lockStore());
        dispatch({ type: types.UPDATE_STORE_FILE, storeFile: config.defaultStore });
        dispatch(persistState());
    };
}

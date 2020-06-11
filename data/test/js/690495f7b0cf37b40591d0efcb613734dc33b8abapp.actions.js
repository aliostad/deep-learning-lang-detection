import { dispatch } from '../lib/disp';
import { dispatch as oldDispatch } from '../lib/dispatcher';
import C from '../constants';


export function toggleLeftPanel() {
    oldDispatch(C.APP_TOGGLE_LEFT_PANEL);
}

export function closeModal() {
    oldDispatch(C.MODAL_CLOSE);
}

export function handleMeData(data) {
    oldDispatch(C.USER_LOGIN_SUCCESS, data.user);
    dispatch(C.USER_LOGIN_SUCCESS, data.user);

    if (data.projects.length) {
        oldDispatch(C.PROJECTS_FETCH_SUCCESS, data.projects);
        dispatch(C.PROJECTS_FETCH_SUCCESS, data.projects);
    }
}

function dispatchLoginState(state) {
    dispatch(C.APP_LOGIN_PAGE_STATE, state);
}


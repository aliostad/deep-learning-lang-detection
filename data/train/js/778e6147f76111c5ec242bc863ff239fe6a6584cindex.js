import {
    REGISTER_BLOCK,
    REGISTER_SECTION,
    REGISTER_PAGE,
    DO_PAGE,
    DO_SECTION,
    DO_BLOCK,
    PASS_PAGE,
    PASS_SECTION
} from './types';

export function registerBlock({ name }) {
    return async function (dispatch) {
        dispatch({ type: REGISTER_BLOCK, payload: { name } });
    };
}

export function registerSection({ name, blocks }) {
    return async function (dispatch) {
        dispatch({ type: REGISTER_SECTION, payload: { name, blocks } });
    };
}

export function registerPage({ name, sections, blocks }) {
    return async function (dispatch) {
        dispatch({ type: REGISTER_PAGE, payload: { name, sections, blocks } });
    };
}

export function doBlock({ name }) {
    return async function (dispatch) {
        dispatch({ type: DO_BLOCK, payload: { name } });
    };
}

export function doSection({ name }) {
    return async function (dispatch) {
        dispatch({ type: DO_SECTION, payload: { name } });
    };
}

export function doPage({ name }) {
    return async function (dispatch) {
        dispatch({ type: DO_PAGE, payload: { name } });
    };
}

export function passSection({ name }) {
    return async function (dispatch) {
        dispatch({ type: PASS_SECTION, payload: { name } });
    };
}

export function passPage({ name }) {
    return async function (dispatch) {
        dispatch({ type: PASS_PAGE, payload: { name } });
    };
}

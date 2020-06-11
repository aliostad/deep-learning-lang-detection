import firebase from 'firebase';
import { Actions } from 'react-native-router-flux';

export function emailChanged (text) {
    return {
        type: 'EMAIL_CHANGED',
        payload: text
    };
};

export function passwordChanged (text) {
    return {
        type: 'PASSW0RD_CHANGED',
        payload: text
    }
}

export function loginUser ({ email, password }) {
    return (dispatch) => {
        dispatch({ type: 'LOGIN_USER'});
        firebase.auth().signInWithEmailAndPassword(email, password)
        .then(user => loginUserSuccess(dispatch, user))
        .catch((error) => {
            firebase.auth().createUserWithEmailAndPassword(email, password)
                .then(user => loginUserSuccess(dispatch, user))
                .catch(() => loginUserFail(dispatch));
        });
    };
};

export function loginUserFail (dispatch) {
    dispatch({
        type: 'LOGIN_USER_FAIL'
    });
}

export function loginUserSuccess (dispatch, user) {
    dispatch({
        type: 'LOGIN_USER_SUCCESS',
        payload: user
    });

    Actions.main();
};
import history from './../utils/history'
import { FireBaseRepository, FireBaseRef } from '../utils/firebaseRepository'

const auth = (user) => {
    return FireBaseRepository.auth(user);
};

export default {
    listenToAuthState() {
        return (dispatch) => {
            FireBaseRef.onAuth((authData) => {
                if (authData) {
                    console.log('listen action says logged in.');
                    dispatch({type: 'SET_LOGIN_USER', email: authData.password.email});
                    dispatch({type: 'LOGIN'});
                }
                else {
                    console.log('listen action says logged out.');
                    dispatch({type: 'LOGOUT'});
                }
            });
        }
    },

    loginUser(user) {
        return async (dispatch) => {
            dispatch({type: 'START_SPINNER'});
            let validation = await auth(user);
            if (validation.isSuccessful) {
                let email = validation.data.password.email;
                dispatch({type: 'LOGIN'});
                dispatch({type: 'SET_LOGIN_USER', email});
                dispatch({type: 'STOP_SPINNER'});
                history.pushState(null, '/');

            } else {
                console.log('not authenticated');
                dispatch({type: 'FAILED_VALIDATION'});
                dispatch({type: 'STOP_SPINNER'});
            }
        }
    },

    logoutUser() {
        return async (dispatch) => {
            dispatch({type: 'LOGOUT'});
            FireBaseRef.unauth();
        }
    }
}

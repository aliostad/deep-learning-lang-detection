import Action, { nav2Main, nav2Index, displayErrorMsg, resource } from '../../actions'
import { UpdateProfile, getHeadline } from '../profile/profileActions'
import { getFollowers } from '../main/followingActions'
import { getArticles } from '../article/articleActions'

export function preMain(username) {
    return (dispatch) => {
        return Promise.all([
            dispatch(UpdateProfile()),
            dispatch(getHeadline(username)),
            dispatch(getFollowers()),
            dispatch(getArticles())
        ]).then(() => {
            dispatch(nav2Main())
        })
    }
}

export function loginAction(username, password) {
    return (dispatch) => {
        return resource('POST', 'login', { username, password })
            .then((response) => {
                dispatch({ type: Action.LOGIN, username: response.username })
                dispatch(preMain(username))
            }).catch((err) => {
                dispatch(displayErrorMsg(`Invalid logging in as user: ${username}`))
            })
    }
}

export function logoutAction() {
    return (dispatch) => {
        return resource('PUT', 'logout')
            .then((response) => {
                dispatch({ type: Action.LOGOUT })
                dispatch(nav2Index())
            }).catch((err) => {
                dispatch(displayErrorMsg(`Invalid logging out: ${err}`))
            })
    }
}
import AuthTypes from '../constants/authTypes'
const apis = require('../apis/auth')

export const login = (formData) => dispatch => {
    console.log(formData)
    return dispatch({
        type: AuthTypes.LOGIN,
        payload: apis.loginAsync(formData)
    }).then(() => null, err => {
        throw new Error(err)
    })
}

export const logout = () => dispatch => {
    return dispatch({
        type: AuthTypes.LOGOUT,
        payload: apis.logoutAsync()
    })
}

export const register = (formData) => dispatch => {
    return dispatch({
        type: AuthTypes.REGISTER,
        payload: apis.registerAsync(formData)
    })
}
export const getUserInfo = (userId) => dispatch => {
    return dispatch({
        type: AuthTypes.GET_USERINFO,
        payload: apis.getUserInfoAsync(userId)
    })
}

export const initAuth = () => dispatch => {
    return dispatch({
        type: AuthTypes.INIT_AUTH,
        payload: apis.initAuthAsync()
    })
        .then(res => {
            return dispatch(getUserInfo(res.value.user._id))
        })
}
export const updateUserInfo = (userId, formData) => dispatch => {
    return dispatch({
        type: AuthTypes.UPDATE_USERINFO,
        payload: apis.updateUserInfoAsync(userId, formData)
    })
}

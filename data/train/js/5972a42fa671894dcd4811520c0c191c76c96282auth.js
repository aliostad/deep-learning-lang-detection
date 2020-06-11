import { POST } from '../api'
import { push } from 'react-router-redux'
import { getMyInfo } from './student'


export const loginUser = (login) => {
  return dispatch => {
    dispatch({ type: 'LOGIN_LOADING' })
    POST('/user/login/', login)
    .then(key => {
      dispatch(push('/'))
      dispatch(getMyInfo())
      return dispatch({ type: 'LOGIN_SUCCESS', payload: key.key })
    })
    .catch(error => {
      if (Promise.resolve(error) === error) {
        return error.then(data => dispatch({ type: 'LOGIN_ERROR', payload: data }))
      } else {
        return error
      }
    })
  }
}

export const logoutUser = () => {
  return dispatch => {
    const tok = localStorage.getItem('key')
    localStorage.setItem('key', '')
    POST('/user/logout/', { 'token': tok })
    dispatch(push('/login'))
    dispatch({ type: 'AUTH_RESET' })
  }
}
export const registerUser = (register) => {
  return dispatch => {
    dispatch({ type: 'LOGIN_LOADING' })
    POST('/user/registration/', register)
    .then(key => {
      dispatch(push('/'))
      dispatch(getMyInfo())
      return dispatch({ type: 'LOGIN_SUCCESS', payload: key.key })
    })
    .catch(error => error.then(data => dispatch({ type: 'LOGIN_ERROR', payload: data })))
  }
}
